import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/features/chat/screens/chat_consultant_screen.dart';
import 'package:mental_healthapp/features/chat/screens/message_screen.dart';
import 'package:mental_healthapp/features/check_in/screens/final_report.dart';
import 'package:mental_healthapp/features/check_in/screens/mood_tracker.dart';
import 'package:mental_healthapp/features/dashboard/controller/dashboard_controller.dart';
import 'package:mental_healthapp/features/dashboard/screens/article/articles_screen.dart';
import 'package:mental_healthapp/models/article_model.dart';
import 'package:mental_healthapp/features/dashboard/screens/article/article_view.dart';
import 'package:mental_healthapp/models/goals_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';
import 'package:mental_healthapp/shared/notification_helper.dart';

import '../../../shared/utils/get_drawer.dart';
import 'package:provider/provider.dart' as provider;

import '../../../shared/utils/goals_database.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  QuestionType? worstType;
  List<GoalModel> list = GoalModel.goalList;

  getWorstScoreType() {
    if (ref.read(profileControllerProvider).isCompletedCheckin()) {
      worstType = ref.read(profileControllerProvider).getWorstScore();
      setState(() {});
    }
  }

  @override
  void initState() {
    final db2 = provider.Provider.of<AppointmentsDB>(context, listen: false);
    db2.loadAppointmentsFromFirebase();
    getWorstScoreType();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceived,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionRecieved,
      onNotificationCreatedMethod: NotificationController.onNotificationCreated,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayed,
    );
    NotificationHelper().triggerMoodNotification();
    NotificationHelper().triggerGoalNotification();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EColors.primaryColor,
      key: _scaffoldKey,
      drawer: GetDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration:  BoxDecoration(
                    color: EColors.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi ${ref.read(profileControllerProvider).getProfileName()} 👋🏻",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
                                  style: GoogleFonts.openSans(
                                      color: Colors.grey[300], fontSize: 15),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: EColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MessageScreen(),
                                        ),
                                      );
                                    },
                                    icon: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
                                      child: Icon(
                                        Icons.message,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: EColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: IconButton(
                                    onPressed: () {
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    icon: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
                                      child: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      Divider(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(
                          leading: Icon(Icons.add_alarm_outlined,color: Colors.white,),
                          title: Text(
                            "Ready for Daily CheckIn",
                            style: TextStyle(
                              color: EColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Let's get started",
                            style: GoogleFonts.openSans(
                                color: Colors.white, fontSize: 15),
                          ),
                          trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              FinalCheckInReport.routename,
                            );
                          },
                          tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
                        ),
                      ),
                      Divider(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(
                          leading: Icon(Icons.mood,color: Colors.white,),
                          title: Text(
                            "How Do You Feel?",
                            style: TextStyle(
                              color: EColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Let's track today's mood",
                            style: GoogleFonts.openSans(
                                color: Colors.white, fontSize: 15),
                          ),
                          trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MoodTracker.routeName,
                            );
                          },
                          tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Suggested Articles",
                            style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ArticlesViewScreen(),
                              ),
                            ),
                            child: Text(
                              "See All",
                              style: GoogleFonts.openSans(
                                  color: EColors.secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *.6,
                      child: FutureBuilder<List<ArticleModel>>(
                        future: ref
                            .read(dashboardControllerProvider)
                            .getWorstArticleType(worstType),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<ArticleModel> articles = snapshot.data ?? [];

                            return ListView.builder(
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                ArticleModel article = articles[index];
                                return ExcerciseTile(
                                  color: article.color,
                                  title: article.title,
                                  subTitle: article.subTitle,
                                  iconData: article.iconData,
                                  articleDes: article.description,
                                  videoUrl: article.videoUrl,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class ExcerciseTile extends StatelessWidget {
  final Color color;
  final String title;
  final String subTitle;
  final IconData iconData;
  final String articleDes;
  final String videoUrl;

  const ExcerciseTile(
      {super.key,
      required this.color,
      required this.title,
      required this.subTitle,
      required this.iconData,
      required this.articleDes,
      required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(
                articleTitle: title,
                articleDes: articleDes,
                iconData: iconData,
                videoUrl: videoUrl,
              ),
            ),
          );
        },
        child:Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color
                // color: Colors.blue
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
                title,
              style: TextStyle(
                color: EColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subTitle,
              style: GoogleFonts.openSans(
                  color: EColors.textPrimary, fontSize: 12),
            ),
            trailing: Icon(Icons.arrow_forward,color: EColors.textPrimary,),
            // onTap: () {
            //   Navigator.pushNamed(
            //     context,
            //     MoodTracker.routeName,
            //   );
            // },
            tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
          ),
        ),

      ),
    );
  }
}

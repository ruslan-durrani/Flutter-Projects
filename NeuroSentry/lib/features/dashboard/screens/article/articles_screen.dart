import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/dashboard/controller/dashboard_controller.dart';
import 'package:mental_healthapp/features/dashboard/repository/dashboard_repository.dart';
import 'package:mental_healthapp/features/dashboard/screens/home.dart';
import 'package:mental_healthapp/models/article_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';

class ArticlesViewScreen extends ConsumerStatefulWidget {
  const ArticlesViewScreen({super.key});

  @override
  ConsumerState<ArticlesViewScreen> createState() => _ArticlesViewScreenState();
}

class _ArticlesViewScreenState extends ConsumerState<ArticlesViewScreen> {
  bool isBookMark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EColors.primaryColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height *.2,
            decoration:  BoxDecoration(
              color: EColors.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.arrow_back,color: Colors.white,),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width *.8,
                            child: Text(
                              "Articles!",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
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
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height *.8,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: FutureBuilder<List<ArticleModel>>(
              future: isBookMark
                  ? ref.read(dashboardRepositoryProvider).fetchBookMarkArticles(
                      ref.read(profileRepositoryProvider).profile!)
                  : ref.read(dashboardControllerProvider).getArticlesFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            isBookMark = !isBookMark;
            setState(() {});
          },
          child: Container(
            height: MediaQuery.of(context).size.width *.2,
            margin: EdgeInsets.only(left: 20,bottom: 20),
            decoration: BoxDecoration(
                color: EColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
                    blurRadius: 10,  // Blur effect radius
                    offset: Offset(5, 5),  // X, Y offset of shadow
                  ),
                ]
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(20),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Show Bookmarks",
                    style: TextStyle(color: EColors.white, fontSize: 16),
                  ),
                  Icon(
                    Icons.bookmark,
                    color: EColors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}

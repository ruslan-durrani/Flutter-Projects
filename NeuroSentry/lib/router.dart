import 'package:flutter/material.dart';
import 'package:mental_healthapp/features/auth/screens/create_profile.dart';
import 'package:mental_healthapp/features/chat/screens/ai_consultant_screen.dart';
import 'package:mental_healthapp/features/chat/screens/chat_consultant_screen.dart';
import 'package:mental_healthapp/features/chat/screens/chat_user_screen.dart';
import 'package:mental_healthapp/features/check_in/screens/final_report.dart';
import 'package:mental_healthapp/features/check_in/screens/mood_tracker.dart';
import 'package:mental_healthapp/features/check_in/screens/questions.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/add_event_screen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/add_status.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/addpostscreen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/comment_screen.dart';
import 'package:mental_healthapp/features/profile/screens/book_marks_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case CreateProfile.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateProfile(),
      );
    case FinalCheckInReport.routename:
      return MaterialPageRoute(
        builder: (context) => const FinalCheckInReport(),
      );

    case MoodTracker.routeName:
      return MaterialPageRoute(
        builder: (context) => const MoodTracker(),
      );
    case QuestionScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => QuestionScreen(
          questionType: args[0],
        ),
      );
    case AddPostScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddPostScreen(),
      );
    case AddEventScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      );
    case BookMarksScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const BookMarksScreen(),
      );
    case AddGroupAndShare.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddGroupAndShare(),
      );
    case ChatUserScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => ChatUserScreen(
          chatRoom: args[0],
        ),
      );
    case ChatConsultantScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => ChatConsultantScreen(
          chatRoom: args[0],
        ),
      );

    case ChatAiScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => ChatAiScreen(
          chatRoom: args[0],
        ),
      );

    case CommentScreen.routeName:
      var args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => CommentScreen(
          post: args[0],
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('This Page Does not Exist'),
          ),
        ),
      );
  }
}

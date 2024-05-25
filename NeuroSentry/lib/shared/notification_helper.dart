// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:mental_healthapp/features/check_in/screens/mood_tracker.dart';
// import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthapp/features/check_in/screens/mood_tracker.dart';
import 'package:mental_healthapp/features/dashboard/screens/goals/goals_home.dart';
import 'package:mental_healthapp/main.dart';

class NotificationHelper {
  triggerMoodNotification() async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Mood Meter',
          body:
              "How are you feeling write now? Update Your current mood at mood meter",
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_MOOD_METER',
            label: 'Open Mood Meter',
            actionType: ActionType.Default,
          ),
        ],
        schedule: NotificationInterval(
            interval: 60,
            repeats: true,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            preciseAlarm: true,
            allowWhileIdle: true));
  }

  triggerGoalNotification() async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 20,
          channelKey: 'goal_channel',
          title: 'Goals',
          body: 'Complete Your Today Goals',
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_GOALS',
            label: 'Open Goals',
            actionType: ActionType.Default,
          ),
        ],
        schedule: NotificationInterval(
            interval: 120,
            repeats: true,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            preciseAlarm: true,
            allowWhileIdle: true));
  }
}

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreated(
      ReceivedNotification receivedNotification) async {}

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {}

  @pragma('vm:entry-point')
  static Future<void> onDismissActionRecieved(
      ReceivedAction receivedAction) async {}

  @pragma('vm:entry-point')
  static Future<void> onActionReceived(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'OPEN_MOOD_METER') {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) {
        return MoodTracker(); // Navigate to MoodTrackerScreen
      }));
    }
    if (receivedAction.buttonKeyPressed == 'OPEN_GOALS') {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) {
        return GoalHomeScreen(); // Navigate to MoodTrackerScreen
      }));
    }
  }
}

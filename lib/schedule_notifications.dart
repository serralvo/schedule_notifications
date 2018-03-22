import 'dart:async';
import 'package:flutter/services.dart';

class ScheduleNotifications {

  static const MethodChannel _channel =  const MethodChannel('schedule_notifications');

  // String text: Text to be showed in notification.
  // DateTime when: When notification should be send.
  // If *repeatAt* is empty, the tool will use this value.
  // List<int> repeatAt: A list of weekdays [1..7]. When 1 is Monday (see DateTime weekday).
  static Future<Null> schedule(String text, DateTime when, List<int> repeatAt) {
    return _channel.invokeMethod('scheduleNotification', [text, when.toString(), repeatAt]);
  }

  static Future<Null> unschedule() {
    return _channel.invokeMethod('unscheduleNotifications');
  }

}

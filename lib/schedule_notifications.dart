import 'dart:async';
import 'package:flutter/services.dart';

class ScheduleNotifications {

  static const MethodChannel _channel =  const MethodChannel('schedule_notifications');

  // TODO: Must add doc
  // text: text to be showed
  // time: hour in minutes or use DateTime
  // repeatAt: [1..7], when 1 is Sunday. check if its ok
  static Future<Null> schedule(text, time, [repeatAt]) {
    return _channel.invokeMethod('scheduleNotification', [text, time, [repeatAt]]);
  }

  static Future<Null> unschedule() {
    return _channel.invokeMethod('unscheduleNotifications');
  }

}

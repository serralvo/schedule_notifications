import 'dart:async';

import 'package:flutter/services.dart';

class ScheduleNotifications {

  static const MethodChannel _channel =  const MethodChannel('schedule_notifications');

  static Future<String> get platformVersion =>  _channel.invokeMethod('getPlatformVersion');

  static Future<Null> schedule(text, time, [repeatIn]) {
    return _channel.invokeMethod('scheduleNotification', [text, time, [repeatIn]]);
  }

  static Future<Null> unschedule() {
    return _channel.invokeMethod('unscheduleNotification');
  }

}

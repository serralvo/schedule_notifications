import 'dart:async';

import 'package:flutter/services.dart';

class ScheduleNotifications {

  static const MethodChannel _channel =  const MethodChannel('schedule_notifications');

  static Future<String> get platformVersion =>  _channel.invokeMethod('getPlatformVersion');

  


}

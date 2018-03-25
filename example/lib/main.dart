import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:schedule_notifications/schedule_notifications.dart';
import 'package:schedule_notifications_example/time_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _platform = const MethodChannel('schedule_notifications_app');

  DateTime _selectedTime = new DateTime.now();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Container(
            child: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new DateTimeItem(
                    dateTime: _selectedTime,
                        onChanged: (value) {
                          setState(() {
                            _selectedTime = value;
                          });
                        }
                    ),
                    new RaisedButton(
                      child: const Text('SCHEDULE'),
                      onPressed: _scheduleAlarm,
                    ),
                  ]
              ),
            )
        ),
      ),
    );
  }

  void _scheduleAlarm() {
    defaultTargetPlatform == TargetPlatform.iOS ? _scheduleiOSAlarm() : _scheduleAndroidAlarm();
  }

  void _scheduleiOSAlarm() {
    try {
      ScheduleNotifications.schedule("Hora de meditar", _selectedTime, [DateTime.saturday]);
    } on Exception {
      print("Whooops :x");
    }
  }

  Future<Null> _scheduleAndroidAlarm() async {
    int iconResourceId;
    try {
      iconResourceId = await _platform.invokeMethod('getIconResourceId');
    } on PlatformException catch (e) {
      print("Error on get icon resource id: x");
    }

    setState(() {
      try {
        ScheduleNotifications.scheduleAndroid("Hora de meditar", _selectedTime, [], iconResourceId);
      } on Exception {
        print("Whooops :x");
      }
    });
  }
}

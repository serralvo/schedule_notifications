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
    if (defaultTargetPlatform == TargetPlatform.android) {
       _getIconResourceId();
    }
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
                    const SizedBox(height: 20.0),
                    new RaisedButton(
                      child: const Text('UNSCHEDULE'),
                      onPressed: _unscheduleAlarm,
                    ),
                  ]
              ),
            )
        ),
      ),
    );
  }

  Future<Null> _getIconResourceId() async {
    int iconResourceId;
    try {
      iconResourceId = await _platform.invokeMethod('getIconResourceId');
    } on PlatformException catch (e) {
      print("Error on get icon resource id: x");
    }

    setState(() {
      ScheduleNotifications.setNotificationIcon(iconResourceId);
    });
  }

  void _scheduleAlarm() {
    try {
      ScheduleNotifications.schedule("Hora de meditar", _selectedTime, []);
    } on Exception {
      print("Whooops :x");
    }
  }

  void _unscheduleAlarm() {
    try {
      ScheduleNotifications.unschedule();
    } on Exception {
      print("Whooops :x");
    }
  }
}

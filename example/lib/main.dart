import 'package:flutter/material.dart';
import 'package:schedule_notifications/schedule_notifications.dart';
import 'package:schedule_notifications_example/time_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                      onPressed: scheduleAlarm,
                    ),
                  ]
              ),
            )
        ),
      ),
    );
  }

  void scheduleAlarm() {
    try {
      ScheduleNotifications.schedule("Hora de meditar", _selectedTime, [DateTime.friday]);
    } on Exception {
      print("Whooops :x");
    }
  }
}

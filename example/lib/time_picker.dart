import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Date time item view.
class DateTimeItem extends StatelessWidget {

  /// Constructor.
  DateTimeItem({ Key key, DateTime dateTime, @required this.onChanged })
      : assert(onChanged != null),
        date = new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  /// Current date.
  final DateTime date;

  /// Current time.
  final TimeOfDay time;

  /// On change listener.
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new DefaultTextStyle(
        style: theme.textTheme.subhead,
        child: new Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: new BoxDecoration(
                      border: new Border(bottom: new BorderSide(color: theme.dividerColor))
                  ),
                  child: new InkWell(
                      onTap: () {
                        showTimePicker(
                            context: context,
                            initialTime: time
                        )
                            .then<Null>((value) {
                          if (value != null)
                            onChanged(new DateTime(date.year, date.month, date.day, value.hour, value.minute));
                        });
                      },
                      child: new Row(
                          children: <Widget>[
                            new Text('${time.format(context)}'),
                            const Icon(Icons.arrow_drop_down, color: Colors.black54),
                          ]
                      )
                  )
              )
            ]
        )
    );
  }
}
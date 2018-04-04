# Schedule Notifications
    A Flutter plugin 🛠 to schedule Local Notifications. Ready for iOS and Android 🚀

[![License][license-image]][license-url]

## Features

- [x] Send local notifications to iOS and Android 📢
- [x] Schedule notifications ⏰

## Requirements

- iOS: Version 10.0+
- Android: minSdkVersion 16

## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
  schedule_notifications: "^0.1.5"
```

## Usage example

### General
- One shot:
```dart
ScheduleNotifications.schedule("Notification Text", new DateTime.now(), []);
```

- Schedule notifications:
```dart
List daysToRepeat = [DateTime.sunday, DateTime.monday]; // repeat every sunday and monday
ScheduleNotifications.schedule("Notification Text", new DateTime.now(), daysToRepeat);
```

- Unschedule:
```dart
ScheduleNotifications.unschedule();
```

### Android
- To set icon of notifications:

```dart
int iconResourceId;
try {
    iconResourceId = await _platform.invokeMethod('getIconResourceId');
} on PlatformException catch (e) {
    print('Error on get icon resource id');
}

ScheduleNotifications.setNotificationIcon(iconResourceId);
```

### iOS
- To request authorization of user:

```dart
ScheduleNotifications.requestAuthorization();
```

## Contribute

We would ❤️ to see your contribution!

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

## About

Created by Fabricio Serralvo and Marcos Aoki.

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

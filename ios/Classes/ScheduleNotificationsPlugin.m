#import "ScheduleNotificationsPlugin.h"
#import <schedule_notifications/schedule_notifications-Swift.h>

@implementation ScheduleNotificationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScheduleNotificationsPlugin registerWithRegistrar:registrar];
}
@end

//
//  NotificationContent.m
//  schedule_notifications
//
//  Created by Cicero Duarte da Silva on 16/04/2018.
//

#import "NotificationContent.h"

@implementation NotificationContent

- (id)initWithContent:(NSArray *)content {
    self = [super init];
    if (self) {

        if ([content objectAtIndex:0] != [NSNull class] ||  [[content objectAtIndex:0] isKindOfClass:[NSString class]]) {
            _title = [content objectAtIndex:0];
        } else {
            return nil;
        }

        if ([content objectAtIndex:1] != [NSNull class] ||  [[content objectAtIndex:1] isKindOfClass:[NSString class]]) {
            NSString * rawDate = [content objectAtIndex:1];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.locale = NSLocale.currentLocale;
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSS";
            _when = [formatter dateFromString:rawDate];
        } else {
            return nil;
        }

        if ([content objectAtIndex:2] != [NSNull class] ||  [[content objectAtIndex:2] isKindOfClass:[NSArray class]]) {
            _repeatAt = [content objectAtIndex:2];
        } else {
            return nil;
        }
    }

    return self;
}

@end

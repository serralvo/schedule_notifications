//
//  NotificationContent.h
//  schedule_notifications
//
//  Created by Cicero Duarte da Silva on 16/04/2018.
//

#import <Foundation/Foundation.h>

@interface NotificationContent : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * when;
@property (nonatomic, strong) NSArray * repeatAt;

- (id)initWithContent:(NSArray *) content;

@end

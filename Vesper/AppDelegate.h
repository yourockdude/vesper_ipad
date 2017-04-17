//
//  AppDelegate.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <UserNotifications/UserNotifications.h>

#import <AFNetworking/AFNetworking.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

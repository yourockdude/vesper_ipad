//
//  AppDelegate.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "AppDelegate.h"

#import "VLogotypeViewController.h"

#import "ICGNavigationController.h"
#import "VRadialAnimation.h"

#import "VUtils.h"

#import "VSettings.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VLogotypeViewController *logotypeVC = [[VLogotypeViewController alloc] init];
    ICGNavigationController *navigationController = [[ICGNavigationController alloc] initWithRootViewController:logotypeVC];
    [navigationController setInteractionEnabled:YES];
    [navigationController setAnimationController:[VRadialAnimation sharedAnimation]];
    [navigationController.navigationBar setTranslucent:YES];
    [navigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //
}

- (void)sendTokentToServer {
    VSettings *settings = [VSettings sharedSettings];
    if (settings.deviceToken) {
        if (!settings.registered) {
            NSLog(@"Send token to server;");
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
            [manager POST:@"http://www.vespermoscow.com/api/register_token.php"
               parameters:@{@"device_token" : settings.deviceToken}
                 progress:^(NSProgress * _Nonnull progress) {
                     //
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if ([responseObject[@"status"] integerValue] == 1) {
                          NSLog(@"Tokent added to data base;");
                          [settings setRegistered:YES];
                      } else if ([responseObject[@"status"] integerValue] == 0) {
                          NSLog(@"Tokent not added to data base;");
                          [settings setRegistered:NO];
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSLog(@"Send device token: failure! Error: %@;", error.localizedDescription);
                      [settings setRegistered:NO];
                  }];
            
        } else {
            NSLog(@"Token is register;");
        }
    } else {
        NSLog(@"Token is null or not allowed notifications;");
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device token: %@", deviceToken);
    if (!deviceToken) {
        return;
    }
    [[VSettings sharedSettings] setDeviceToken:[VUtils stringWithDeviceToken:deviceToken]];
    [self sendTokentToServer];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
    [[VSettings sharedSettings] setRegistered:NO];
}

#ifdef SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO_IOS_10

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"User info: %@", notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    completionHandler();
}

#else

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //
}

#endif

@end

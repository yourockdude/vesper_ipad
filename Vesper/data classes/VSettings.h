//
//  VSettings.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 26.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "VObject.h"


#define SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO_IOS_10 ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)


@protocol VSettingDelegate <NSObject>

@optional

- (void)didFailureWithError:(NSString *)error;

- (void)didStartInitialLocalizedData;
- (void)didFinishInitialLocalizedData;

- (void)didStartLoadData;
- (void)didFinishLoadData;

- (void)didStartCachingPhotos;
- (void)didFinishCachingPhotos;

- (void)didFinishCahingDocuments;

- (void)didDownloadChangelog:(NSDictionary *)changelog;

- (void)didCompleateDownloadWithProgress:(CGFloat)progress;

@end


@interface VSettings : NSObject

@property (strong, nonatomic) id <VSettingDelegate> delegate;

@property (strong, nonatomic) NSMutableArray <VObject *> *objects;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *version;

@property (assign, nonatomic) BOOL isNotFirstLaunch;
@property (assign, nonatomic) BOOL registered;

@property (assign, nonatomic) BOOL availability;

@property (assign, nonatomic) NSUInteger badge;

@property (strong, nonatomic) NSDictionary *changelog;

+ (id)sharedSettings;

- (void)updateDataFromServer;

- (void)initialLocalizedDataWithResponce:(id)responce;

- (void)loadLocalizedDataFromCache;

- (void)checkUpdates;

- (void)updateVersionOfDeviceToken;

- (void)documentByURL:(NSString *)URL
           completion:(void (^)(NSData *data))completion;

@end

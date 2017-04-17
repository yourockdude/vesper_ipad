//
//  VSettings.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 26.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VSettings.h"

#import "VUtils.h"

#import "CMDataStorage.h"

#import "SDImageCache.h"

#import <AFNetworking/AFNetworking.h>


#define kIsNotFirstLaunch (@"is_not_first_launch")
#define kDeviceToken (@"device_token")
#define kVersion (@"version")
#define kRegistered (@"registered")
#define kAvailability (@"availability")

#define kURL (@"http://mobile.vespermoscow.com/")
#define kAPI (@"api/")


@interface VSettings ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (strong, nonatomic) NSMutableArray *photosArray;
@property (strong, nonatomic) NSMutableArray *documentsArray;

@property (assign, nonatomic) NSUInteger index;

@property (assign, nonatomic) BOOL ruDataStored;
@property (assign, nonatomic) BOOL enDataStored;

@property (assign, nonatomic) NSUInteger progressIndex;

@end

@implementation VSettings

@synthesize delegate = _delegate;

@synthesize objects = _objects;

@synthesize deviceToken = _deviceToken;
@synthesize version = _version;

@synthesize isNotFirstLaunch = _isNotFirstLaunch;
@synthesize registered = _registered;
@synthesize availability = _availability;

@synthesize badge = _badge;

@synthesize changelog = _changelog;

#pragma mark - Life cycle

+ (VSettings *)sharedSettings {
    static VSettings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[VSettings alloc] initSettings];
    });
    return settings;
}

- (instancetype)initSettings {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _objects = [[NSMutableArray alloc] init];
        _photosArray = [[NSMutableArray alloc] init];
        _documentsArray = [[NSMutableArray alloc] init];
        _index = 0;
    }
    return self;
}

#pragma mark - Custom accessors

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = [_userDefaults objectForKey:kDeviceToken];
    if (!_deviceToken) {
        [_userDefaults setObject:deviceToken
                          forKey:kDeviceToken];
        if ([_userDefaults synchronize]) {
            _deviceToken = deviceToken;
        }
    }
}

- (NSString *)deviceToken {
    if (!_deviceToken) {
        _deviceToken = [_userDefaults objectForKey:kDeviceToken];
    }
    NSLog(@"Truncated device token: %@;", _deviceToken);
    return _deviceToken;
}

- (void)setVersion:(NSString *)version {
    [_userDefaults setObject:version
                      forKey:kVersion];
    if ([_userDefaults synchronize]) {
        _version = version;
        NSLog(@"Set version: %@;", _version);
    }
}

- (NSString *)version {
    if (!_version) {
        _version = [_userDefaults objectForKey:kVersion];
    }
    NSLog(@"Get version: %@;", _version);
    return _version;
}

- (void)setIsNotFirstLaunch:(BOOL)isNotFirstLaunch {
    [_userDefaults setBool:isNotFirstLaunch
                    forKey:kIsNotFirstLaunch];
    if ([_userDefaults synchronize]) {
        _isNotFirstLaunch = isNotFirstLaunch;
    }
}

- (BOOL)isNotFirstLaunch {
    _isNotFirstLaunch = [_userDefaults boolForKey:kIsNotFirstLaunch];
    return _isNotFirstLaunch;
}

- (void)setRegistered:(BOOL)registered {
    [_userDefaults setBool:registered
                    forKey:kRegistered];
    if ([_userDefaults synchronize]) {
        _registered = registered;
    }
}

- (BOOL)registered {
    _registered = [_userDefaults boolForKey:kRegistered];
    return _registered;
}

- (void)setAvailability:(BOOL)availability {
    [_userDefaults setBool:availability
                    forKey:kAvailability];
    if ([_userDefaults synchronize]) {
        _availability = availability;
    }
}

- (BOOL)availability {
    _availability = [_userDefaults boolForKey:kAvailability];
    return _availability;
}

- (void)setChangelog:(NSDictionary *)changelog {
    [_userDefaults setObject:changelog
                      forKey:@"changelog"];
    if ([_userDefaults synchronize]) {
        [_userDefaults synchronize];
    }
}

- (NSDictionary *)changelog {
    if (!_changelog) {
        _changelog = [_userDefaults objectForKey:@"changelog"];
    }
    return _changelog;
}

#pragma mark - Methods

- (void)updateDataFromServer {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager POST:[NSString stringWithFormat:@"%@%@%@", kURL, kAPI, @"select_objects.php"]
       parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             //
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [self initialLocalizedDataWithResponce:responseObject];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error update: %@;", error.localizedDescription);
              if (_delegate) {
                  [_delegate didFailureWithError:error.localizedDescription];
              }
          }];
}

- (void)initialLocalizedDataWithResponce:(id)responce {
    NSLog(@"Protocol: didStartInitialLocalizedData;");
    if (_delegate) {
        [_delegate didStartInitialLocalizedData];
    }
    NSDictionary *dictionary = responce;
    NSLog(@"Version: %@;", dictionary[@"version"]);
    if (dictionary[@"version"] != [NSNull null]) {
        [self setVersion:dictionary[@"version"]];
    } else {
        return;
    }
    CMDataStorage *storage = [CMDataStorage sharedDocumentsStorage];
    for (NSString *localize in @[@"RU", @"EN"]) {
        if (dictionary[localize] == [NSNull null]) {
            NSLog(@"Localize %@ is empty;", localize);
            return;
        }
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary[localize]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        if (error) {
            NSLog(@"Error converting dictionary to data;");
            return;
        }
        [storage writeData:data
                       key:localize
                     block:^(BOOL succeeds) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSLog(@"Data %@ stored;", localize);
                             [self checkStoredForLocalize:localize];
                         });
                     }];
    }
}

- (void)loadLocalizedDataFromCache {
    NSLog(@"Protocol: didStartLoadData;");
    if (_delegate) {
        [_delegate didStartLoadData];
    }
    [_objects removeAllObjects];
    [self localizedDataWithCompletion:^(NSDictionary *dictionary) {
        NSArray *array = (NSArray *)dictionary;
        for (NSUInteger i = 0; i <= array.count - 1; i++) {
            VObject *object = [[VObject alloc] init];
            object.identifier = [array[i][@"identifier"] integerValue];
            object.latitude = [array[i][@"latitude"] floatValue];
            object.longitude = [array[i][@"longitude"] floatValue];
            object.type = [array[i][@"type"] integerValue];
            object.name = array[i][@"name"];
            object.address = array[i][@"address"];
            object.littleDescription = array[i][@"little_description"];
            object.ready = array[i][@"deadline"];
            object.square = array[i][@"square"];
            object.apartmentsCount = [array[i][@"apartments_count"] integerValue];
            object.largeDescription = array[i][@"large_description"];
            object.location = array[i][@"location"];
            object.team = array[i][@"team"];
            object.customURL = array[i][@"customURL"];
            object.objectURL = array[i][@"objectURL"];
            object.documentURL = array[i][@"documentURL"];
            object.email = array[i][@"email"];
            object.telephone = array[i][@"telephone"];
            object.photos = [[NSMutableArray alloc] init];
            NSArray *photosArray = (NSArray *)array[i][@"photos"];
            NSLog(@"Oject: %ld, photos count: %ld;", (unsigned long)i, (unsigned long)photosArray.count);
            for (NSUInteger j = 0; j <= photosArray.count - 1; j++) {
                [object.photos addObject:photosArray[j][@"imageURL"]];
            }
            [_objects addObject:object];
        }
        NSLog(@"Objects: %@;", _objects);
        NSLog(@"Protocol: didFinishLoadData;");
        if (_delegate) {
            [_delegate didFinishLoadData];
        }
        [self cachePhotos];
    }];
}

- (void)checkStoredForLocalize:(NSString *)localize {
    if ([localize isEqualToString:@"RU"]) {
        _ruDataStored = YES;
    }
    if ([localize isEqualToString:@"EN"]) {
        _enDataStored = YES;
    }
    if (_ruDataStored && _enDataStored) {
        NSLog(@"Protocol: didFinishInitialLocalizedData;");
        [APPLICATION setApplicationIconBadgeNumber:0];
        [self setChangelog:nil];
        _ruDataStored = NO;
        _enDataStored = NO;
        if (_delegate) {
            [_delegate didFinishInitialLocalizedData];
        }
        [self loadLocalizedDataFromCache];
    }
}

- (void)checkLocalizedDataWithLocalize:(NSString *)localize
                            completion:(void (^)(NSDictionary *dictionary))completion {
    CMDataStorage *storage = [CMDataStorage sharedDocumentsStorage];
    [storage dataForKey:localize
                  block:^(NSData *data) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (!data) {
                              NSLog(@"Data is nil;");
                          }
                          NSError *error;
                          NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:NSJSONReadingMutableLeaves
                                                                                       error:&error];
                          if (error) {
                              NSLog(@"Serialization error: %@;", error.localizedDescription);
                              return;
                          }
                          if (completion) {
                              completion(dictionary);
                          }
                      });
                  }];
}

- (void)updateVersionOfDeviceToken {
    if ([self registered] && [self deviceToken]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
        [manager POST:[NSString stringWithFormat:@"%@%@%@", kURL, kAPI, @"update_version_of_device_token.php"]
           parameters:@{@"device_token" : [self deviceToken]}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if ([responseObject[@"status"] integerValue] == 1) {
                      NSLog(@"Version of device token updated;");
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Updates version of device token error: %@;", error.localizedDescription);
              }];
    } else {
        NSLog(@"Device token not registred;");
    }
}

- (void)checkUpdates {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager POST:[NSString stringWithFormat:@"%@%@%@", kURL, kAPI, @"check_updates.php"]
       parameters:@{@"version" : [self version]}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"Changelog responce: %@;", responseObject);
              if (!_delegate) {
                  return;
              }
              if ([responseObject[@"status"] integerValue] == 1) {
                  [self setChangelog:(NSDictionary *)responseObject[@"answer"]];
                  _badge = [self changelog].count;
                  [APPLICATION setApplicationIconBadgeNumber:_badge];
                  [_delegate didDownloadChangelog:[self changelog]];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Check updates error: %@;", error.localizedDescription);
              if ([self changelog] == nil) {
                  NSLog(@"Changelog from storage is nil;");
                  return;
              }
              if (_delegate) {
                  NSLog(@"Changelog from storage: %@;", [self changelog]);
                  _badge = [self changelog].count;
                  [APPLICATION setApplicationIconBadgeNumber:_badge];
                  [_delegate didDownloadChangelog:[self changelog]];
              }
          }];
}

- (void)localizedDataWithCompletion:(void (^)(NSDictionary *dictionary))completion {
    NSString *language = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSString *languageCode;
    if ([language isEqualToString:@"ru"]) {
        languageCode = @"RU";
    } else {
        languageCode = @"EN";
    }
    NSLog(@"Language code: %@;", languageCode);
    [self checkLocalizedDataWithLocalize:languageCode
                              completion:^(NSDictionary *dictionary) {
                                  if (completion) {
                                      completion(dictionary);
                                  }
                              }];
}

- (void)cachePhotos {
    NSLog(@"Protocol: didStartCachingPhotos;");
    if (_delegate) {
        [_delegate didStartCachingPhotos];
    }
    for (VObject *object in _objects) {
        for (NSString *URL in object.photos) {
            [_photosArray addObject:URL];
        }
        if (![object.documentURL isEqualToString:@""]) {
            [_documentsArray addObject:object.documentURL];
        }
    }
    if (_photosArray.count > 0) {
        [self cycleOfCacheWithIndex:0];
    } else {
        if (_delegate) {
            [_delegate didFailureWithError:@"Critical error: no photoes in database!"];
        }
    }
}

- (void)cycleOfCacheWithIndex:(NSUInteger)index {
    if (index > _photosArray.count - 1) {
        NSLog(@"Protocol: didFinishCachingPhotos;");
        if (_delegate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate didFinishCachingPhotos];
            });
        }
        if (_documentsArray.count > 0) {
            _index = 0;
            [self cycleOfCacheDocumentsWithIndex:0];
        } else {
            NSLog(@"No documaents;");
            [self finishAllCache];
        }
        return;
    }
    NSLog(@"Progress cache photos: %ld of %ld;", (unsigned long)index + 1, (unsigned long)_photosArray.count);
    [self checkImageWithURL:_photosArray[index]];
}

- (void)cycleOfCacheDocumentsWithIndex:(NSUInteger)index {
    if (index > _documentsArray.count - 1) {
        [self finishAllCache];
        return;
    }
    NSLog(@"Progress cache documents: %ld of %ld, URL: %@", (unsigned long)index + 1, (unsigned long)_documentsArray.count, _documentsArray[index]);
    [self checkDocumentWithURL:_documentsArray[index]];
}

- (void)calculateProgress {
    _progressIndex++;
    if (_delegate) {
        [_delegate didCompleateDownloadWithProgress:(CGFloat)_progressIndex / (_photosArray.count + _documentsArray.count)];
    }
}

- (void)finishAllCache {
    NSLog(@"Protocol: didFinishCachingDocuments;");
    [_photosArray removeAllObjects];
    [_documentsArray removeAllObjects];
    _index = 0;
    _progressIndex = 0;
    if (_delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate didFinishCahingDocuments];
        });
    }
}

- (void)checkImageWithURL:(NSString *)URL {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:URL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (!image) {
                                                             [self cacheImageWithURL:URL];
                                                         } else {
                                                             _index++;
                                                             [self calculateProgress];
                                                             [self cycleOfCacheWithIndex:_index];
                                                         }
                                                     }];
}

- (void)cacheImageWithURL:(NSString *)URL {
    [self dataFromURL:URL
           completion:^(NSData *data, NSError *error) {
               if (data && !error) {
                   NSLog(@"Download and cache image: %@;", URL);
                   [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithData:data]
                                                        forKey:URL];
               }
               _index++;
               [self calculateProgress];
               [self cycleOfCacheWithIndex:_index];
           }];
}

- (void)checkDocumentWithURL:(NSString *)URL {
    CMDataStorage *storage = [CMDataStorage sharedDocumentsStorage];
    [storage dataForKey:URL
                  block:^(NSData *data) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (data) {
                              _index++;
                              [self calculateProgress];
                              [self cycleOfCacheDocumentsWithIndex:_index];
                          } else {
                              [self cacheDocumentWithURL:URL];
                          }
                      });
                  }];
}

- (void)cacheDocumentWithURL:(NSString *)URL {
    [self dataFromURL:URL
           completion:^(NSData *data, NSError *error) {
               if (data && !error) {
                   CMDataStorage *storage = [CMDataStorage sharedDocumentsStorage];
                   [storage writeData:data
                                  key:URL
                                block:^(BOOL succeeds) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (succeeds) {
                                            NSLog(@"Document cached;");
                                        }
                                        _index++;
                                        [self calculateProgress];
                                        [self cycleOfCacheDocumentsWithIndex:_index];
                                    });
                                }];
               } else {
                   _index++;
                   [self calculateProgress];
                   [self cycleOfCacheDocumentsWithIndex:_index];
               }
           }];
}

- (void)dataFromURL:(NSString *)URL
         completion:(void (^)(NSData *data, NSError *error))completion {
    NSLog(@"Start session;");
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:URL]
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    NSLog(@"Stop session;");
                                                    if (error) {
                                                        NSLog(@"Session error: %@;", error);
                                                    }
                                                    if (!data) {
                                                        NSLog(@"Empty data: %@;", data);
                                                    }
                                                    if (completion) {
                                                        completion(data, error);
                                                    }
                                                });
                                            }];
    [dataTask resume];
}

- (void)documentByURL:(NSString *)URL
           completion:(void (^)(NSData *data))completion {
    CMDataStorage *storage = [CMDataStorage sharedDocumentsStorage];
    [storage dataForKey:URL
                  block:^(NSData *data) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (!data) {
                              NSLog(@"No data;");
                          }
                          if (completion) {
                              completion(data);
                          }
                      });
                  }];
}

@end

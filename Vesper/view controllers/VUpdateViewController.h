//
//  VUpdateViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 11.01.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VUpdateViewDelegate <NSObject>

@required

- (void)didUpdateComplete;

@end


@interface VUpdateViewController : UIViewController

@property (assign, nonatomic) id <VUpdateViewDelegate> delegate;

@property (strong, nonatomic) UIViewController *rootViewController;

- (instancetype)initWithChangelog:(NSDictionary *)changelog;

- (void)show;
- (void)hide;

@end

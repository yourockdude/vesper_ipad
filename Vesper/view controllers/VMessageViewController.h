//
//  VMessageViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 18.01.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VMessageViewControllerDelegate <NSObject>

@optional

- (void)didButton_TUI;

@end


@interface VMessageViewController : UIViewController

@property (strong, nonatomic) id <VMessageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIViewController *rootViewController;

@property (strong, nonatomic) NSString *messageTitle;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *buttonTitle;

- (instancetype)initWithTitle:(NSString *)title
                  withMessage:(NSString *)message
                    andButton:(NSString *)button;

- (void)show;
- (void)hide;

@end

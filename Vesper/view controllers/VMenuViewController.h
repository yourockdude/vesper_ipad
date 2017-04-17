//
//  VMenuViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, VMenuViewItem) {
    VMenuViewItemNone = 0,
    VMenuViewItemAboutUs = 1,
    VMenuViewItemObjects = 2,
    VMenuViewItemContacts = 3,
    VMenuViewItemNews = 4,
    VMenuViewItemCall = 5,
    VMenuViewItemUpdates = 6
};


@protocol VMenuViewControllerDelegate <NSObject>

@optional

- (void)didSelectMenuViewControllerItemWithViewController:(UIViewController *)viewController;

- (void)didCloseMenu;

@end


@interface VMenuViewController : UIViewController

@property (assign, nonatomic) id <VMenuViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isShowed;

@property (strong, nonatomic) NSDictionary *changelog;

+ (id)sharedMenuViewController;

- (void)showAnimated:(BOOL)animated
      withCompletion:(void (^)())completion;
- (void)hideAnimated:(BOOL)animated
      withCompletion:(void (^)())completion;

@end

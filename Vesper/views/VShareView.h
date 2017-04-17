//
//  VShareView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 08.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VShareViewDelegate <NSObject>

@optional

- (void)didCloseShareView;

- (void)didSendSms;
- (void)didDownloadPdf;
- (void)didSendEmail;
- (void)didWhatsapp;

@end


@interface VShareView : UIView

@property (assign, nonatomic) id <VShareViewDelegate> delegate;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end

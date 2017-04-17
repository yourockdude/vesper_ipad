//
//  VTeamView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 12.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VTeamViewDelegate <NSObject>

@optional

- (void)didTUISite_1;
- (void)didTUISite_2;

@end


@interface VTeamView : UIView

@property (strong, nonatomic) id <VTeamViewDelegate> delegate;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *site_1;
@property (strong, nonatomic) NSString *site_2;

@end

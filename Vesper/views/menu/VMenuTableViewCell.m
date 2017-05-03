//
//  VMenuTableViewCell.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 31.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VMenuTableViewCell.h"

#import "VUtils.h"


@interface VMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation VMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted
              animated:(BOOL)animated {
    [super setHighlighted:highlighted
                 animated:animated];
    [_label setHighlighted:highlighted];
}

- (void)setTitle:(NSString *)title {
    [_label setText:title];
}

@end

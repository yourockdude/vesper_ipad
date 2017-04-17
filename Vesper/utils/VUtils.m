//
//  VUtils.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VUtils.h"


@implementation VUtils

+ (void)applyCornerRadii:(NSArray *)cornerRadii
                forViews:(NSArray<UIView *> *)views {
    for (int i = 0; i <= views.count - 1; i++) {
        views[i].layer.cornerRadius = [cornerRadii[i] floatValue];
        views[i].clipsToBounds = YES;
    }
}

+ (void)registerStringNameTableViewCellClass:(NSString *)stringName
                                forTableView:(UITableView *)tableView
                         withReuseIdentifier:(NSString *)reuseIdentifier {
    [tableView registerNib:[UINib nibWithNibName:stringName
                                          bundle:nil]
    forCellReuseIdentifier:reuseIdentifier];
}

+ (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deviceTokenString;
}

@end

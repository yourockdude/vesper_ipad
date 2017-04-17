//
//  VDocumentViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 06.03.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface VDocumentViewController : UIViewController

- (instancetype)initWithData:(NSData *)data
                    andTitle:(NSString *)title;

@end

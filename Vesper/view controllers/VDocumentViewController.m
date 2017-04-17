//
//  VDocumentViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 06.03.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import "VDocumentViewController.h"


@interface VDocumentViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSData *data;

@property (strong, nonatomic) NSString *documentTitle;

@end


@implementation VDocumentViewController

- (instancetype)initWithData:(NSData *)data
                    andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _data = data;
        _documentTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_titleLabel setText:_documentTitle];
    NSURL *URL;
    [_webView setScalesPageToFit:YES];
    [_webView loadData:_data
              MIMEType:@"application/pdf"
      textEncodingName:@"UTF-8"
               baseURL:URL];
}

- (IBAction)backButton_TUI:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end

//
//  SharePopupViewController.m
//  KhmerFood
//
//  Created by kvc on 3/3/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "SharePopupViewController.h"

@interface SharePopupViewController ()

@end

@implementation SharePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareAction:(UIButton *)sender {
    if (sender.tag == 94) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonClicked:)]) {
            [self.delegate closeButtonClicked:self];
        }
    } else if (sender.tag == 90) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareToFaceBookClicked:)]) {
            [self.delegate shareToFaceBookClicked:self];
        }
    } else if (sender.tag == 91) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareToTwitterClicked:)]) {
            [self.delegate shareToTwitterClicked:self];
        }
    } else if (sender.tag == 92) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareToLineClicked:)]) {
            [self.delegate shareToLineClicked:self];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareToFriendClicked:)]) {
            [self.delegate shareToFriendClicked:self];
        }
    }
}



@end

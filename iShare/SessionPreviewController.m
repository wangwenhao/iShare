//
//  SessionPreviewController.m
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionPreviewController.h"

@interface SessionPreviewController ()

@end

@implementation SessionPreviewController
@synthesize sessionInfoView = _sessionInfoView;
@synthesize button = _button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"课程信息";
    self.view = _sessionInfoView;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    if([_button.currentTitle isEqualToString:@"报名"])
    {
        [_button setTitle:@"签到" forState:UIControlStateNormal];
        return;
    }
    if([_button.currentTitle isEqualToString:@"签到"])
    {
        [_button setTitle:@"评论" forState:UIControlStateNormal];
        return;
    }
    if([_button.currentTitle isEqualToString:@"评论"]){
        [_button setTitle:@"已评论" forState:UIControlStateNormal];
        [_button setEnabled:NO];
        return;
    }
}
@end

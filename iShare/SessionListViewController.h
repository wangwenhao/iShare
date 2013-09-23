//
//  SessionListViewController.h
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SessionPreviewController.h"
#import "MySessionViewController.h"

@interface SessionListViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *sessionList;

@property(nonatomic, strong) MainViewController *mainViewController;

@property (nonatomic, strong) MySessionViewController *mySessionViewController;

@property (nonatomic, strong) SessionPreviewController *sessionPreviewController;

@end

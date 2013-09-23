//
//  MySessionViewController.h
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionPreviewController.h"

@interface MySessionViewController : UITableViewController

@property (nonatomic, strong) NSArray *mySession;

@property (nonatomic, strong) SessionPreviewController *sessionPreviewController;

@end

//
//  LoginViewController.h
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionListViewController.h"

@interface LoginViewController : UIViewController

@property (nonatomic, strong) SessionListViewController *sessionListViewController;

- (IBAction)userLogin:(id)sender;

@end

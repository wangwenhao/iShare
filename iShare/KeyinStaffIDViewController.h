//
//  KeyinStaffIDViewController.h
//  iShare
//
//  Created by Bryant on 3/3/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyinStaffIDViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *staffID;
- (IBAction)saveNoRegistedStaff:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end

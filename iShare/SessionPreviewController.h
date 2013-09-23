//
//  SessionPreviewController.h
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionPreviewController : UIViewController

- (IBAction)buttonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *sessionInfoView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@end

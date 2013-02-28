//
//  SessionInfoPreviewViewController.h
//  iShare
//
//  Created by Bryant on 2/28/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionInfoPreviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *sessionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lectureLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionDescLabel;

@property (strong, nonatomic) NSDictionary *sessionDetails;

- (IBAction)saveCurrentSession:(id)sender;
- (IBAction)rescan:(id)sender;

- (id)initWithSessionInfo:(NSDictionary *)sessionInfo;

@end

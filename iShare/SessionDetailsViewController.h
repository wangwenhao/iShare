//
//  SessionDetailsViewController.h
//  iShare
//
//  Created by Bryant on 3/4/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionModel.h"

@interface SessionDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSNumber *sessionId;
    Session *session;
    NSArray *audiences;
    NSIndexPath *currentIndex;
}

@property (strong, nonatomic) IBOutlet UILabel *sessionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionLecturerLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionTimeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIAlertView *waitingAlert;

-(id)initWithSessionId:(NSNumber *)sid;
-(void)uploadData:(id)sender;
-(void)getLottery:(id)sender;
@end

//
//  SessionHistoryListViewController.h
//  iShare
//
//  Created by Bryant on 2/21/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDetailsViewController.h"

@interface SessionHistoryListViewController : UITableViewController<UIAlertViewDelegate>
{
    NSIndexPath *_currentIndex;
    UITableView *_tv;
}

@property (strong, nonatomic) NSArray *session;
@property (strong, nonatomic) SessionDetailsViewController *detailsViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

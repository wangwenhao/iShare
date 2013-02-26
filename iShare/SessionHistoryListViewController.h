//
//  SessionHistoryListViewController.h
//  iShare
//
//  Created by Bryant on 2/21/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionHistoryListViewController : UITableViewController

@property (strong, nonatomic) NSArray *session;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

//
//  SessionViewCell.h
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *SessionImage;
@property (strong, nonatomic) IBOutlet UILabel *sessionName;
@property (strong, nonatomic) IBOutlet UILabel *lecturer;
@property (strong, nonatomic) IBOutlet UILabel *sessionTime;

@end

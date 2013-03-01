//
//  Audience.h
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Audience: NSManagedObject

@property (nonatomic, retain) NSDate * attendTime;
@property (nonatomic, retain) NSNumber * audienceID;
@property (nonatomic, retain) NSString * checkinIndicator;
@property (nonatomic, retain) NSNumber * lotteryIndicator;
@property (nonatomic, retain) NSString * staffID;
@property (nonatomic, retain) NSString * staffName;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * winIndicator;
@property (nonatomic, retain) NSManagedObject *session;

@end

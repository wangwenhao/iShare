//
//  Session.h
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Audience;

@interface Session: NSManagedObject

@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * lecturer;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * scanedTime;
@property (nonatomic, retain) NSNumber * sessionID;
@property (nonatomic, retain) NSString * sessionName;
@property (nonatomic, retain) NSString * sessionDesc;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * uploadIndicator;
@property (nonatomic, retain) NSSet *audiences;
@end


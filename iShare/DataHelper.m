//
//  DataHelper.m
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

#import "DataHelper.h"
#import "Constants.h"

@implementation DataHelper

+ (Audience *) scannedInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSNumber *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context{
    Audience *aModel = [NSEntityDescription insertNewObjectForEntityForName:AUDIENCEMODEL inManagedObjectContext:context];
    
    Session *sModel = [self getSessionForID:sessionId inContext:context];
    if (sModel == nil) {
        NSString *sValue = [sessionId stringValue];
        NSLog(@"Can't find data where SessionId= %@", sValue);
	    abort();
    } else {
        aModel.checkinIndicator = @"Y";
        aModel.attendTime = [NSDate date];
        aModel.lotteryIndicator = [NSNumber numberWithInt:1];
        aModel.staffID = staffId;
        aModel.staffName = staffName;
        aModel.userID = userId;
        aModel.winIndicator = [NSNumber numberWithInt:0];
        aModel.session = sModel;
        
        [self saveContext:context];
    }
    
    return aModel;
}

+ (Audience *) keyInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSNumber *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context{
    Audience *aModel = [NSEntityDescription insertNewObjectForEntityForName:AUDIENCEMODEL inManagedObjectContext:context];
    
    Session *sModel = [self getSessionForID:sessionId inContext:context];
    if (sModel == nil) {
        NSString *sValue = [sessionId stringValue];
        NSLog(@"Can't find data where SessionId= %@", sValue);
	    abort();
    } else {
        aModel.checkinIndicator = @"Y";
        aModel.attendTime = [NSDate date];
        aModel.lotteryIndicator = [NSNumber numberWithInt:0];
        aModel.staffID = staffId;
        aModel.staffName = staffName;
        aModel.userID = userId;
        aModel.winIndicator = [NSNumber numberWithInt:0];
        aModel.session = sModel;
        [self saveContext:context];
    }
    
    return aModel;
    
}

+ (bool) updateAudienceWithAudienceId:(NSNumber *)aId andWinLottery:(NSNumber *)winStatus inContext:(NSManagedObjectContext *)context{
    Audience *aModel = [self getAudienceByAudienceId:aId inContext:context];
    
    if(aModel != nil){
        aModel.winIndicator = winStatus;
        [self saveContext:context];
        return YES;
    }else{
        NSLog(@"Can't find the Audience with AudienceId=%@",[aId stringValue]);
        return NO;
    }
}

+ (bool) saveAudienceWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context{
  	Audience *aModel = [NSEntityDescription insertNewObjectForEntityForName:AUDIENCEMODEL inManagedObjectContext:context];

        NSString *temp= [JSONDic objectForKey: @"sessionid"];
        if(temp== @""){
              NSLog(@"sessionId  can't be empty");
              return NO;
        }
    
    Session *sModel = [self getSessionForID:temp inContext:context];
    if (sModel == nil) {
        NSString *sValue = [temp stringValue];
        NSLog(@"Can't find data where SessionId= %@", sValue);
	   return NO;
    }else{
        aModel.session= sModel;
    }

NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
[f setNumberStyle:NSNumberFormatterDecimalStyle];
NSNumber *myNumber;
temp= [JSONDic objectForKey: @"userid"];
if(temp== @""){
              //NSLog(@"userid can't be empty");
              //return NO;
         //without userId, this user is manual key in user.
         aModel.lotteryIndicator = [NSNumber numberWithInt:0];
}else{       
       *myNumber = [f numberFromString:temp];      
       aModel.userID = myNumber;
       aModel.lotteryIndicator = [NSNumber numberWithInt:1];
    }
   aModel.checkinIndicator = @"Y";
   aModel.attendTime = [NSDate date];
   aModel.winIndicator = [NSNumber numberWithInt:0];

temp= [JSONDic objectForKey: @"staffid"];
if(temp== @""){
              NSLog(@"staffid can't be empty");
              return NO;
}else{       
       *myNumber = [f numberFromString:temp];       
       aModel.staffID = myNumber;
    }
 
temp= [JSONDic objectForKey: @"staffname"];
if(temp== @""){
              NSLog(@"staffname can't be empty");
              return NO;
}else{             
       aModel.staffName = temp;
    }
  [self saveContext:context];

   return YES;
}

+ (Session *) scannedInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andStatus:(NSString *)status inContext:(NSManagedObjectContext *)context{
    
    Session *sModel = [self getSessionForID:sessionId inContext:context];
    
    if (sModel != nil) {
        NSString *sValue = [sessionId stringValue];
        NSLog(@"already exist the session with SessionId= %@, just return the session from context.", sValue);
	    //abort();
    } else {
        sModel = [NSEntityDescription insertNewObjectForEntityForName:SESSIONMODEL inManagedObjectContext:context];
        sModel.sessionID = sessionId;
        sModel.sessionDesc = sDesc;
        sModel.location=location;
        sModel.departmentName = deptName;
        sModel.scanedTime = [NSDate date];
        sModel.sessionName = sessionName;
        sModel.lecturer = lecturer;
        sModel.startTime = startTime;
        sModel.endTime = endTime;
        sModel.status = status;
        
        [self saveContext:context];
    }
    
    return sModel;
}

+ (Session *) keyInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime inContext:(NSManagedObjectContext *)context{
    
    Session *sModel = [self getSessionForID:sessionId inContext:context];
    
    if (sModel != nil) {
        NSString *sValue = [sessionId stringValue];
        NSLog(@"already exist the session with SessionId= %@,just return the session from context.", sValue);
	    //abort();
    } else {
        sModel = [NSEntityDescription insertNewObjectForEntityForName:SESSIONMODEL inManagedObjectContext:context];
        sModel.sessionID = sessionId;
        sModel.sessionDesc = sDesc;
        sModel.location=location;
        sModel.departmentName = deptName;
        sModel.scanedTime = [NSDate date];
        sModel.sessionName = sessionName;
        sModel.lecturer = lecturer;
        sModel.startTime = startTime;
        sModel.endTime = endTime;
        sModel.status = @"Open";
        [self saveContext:context];
    }
    
    return sModel;
}

+ (Session *) getSessionForID:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *query = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:SESSIONMODEL inManagedObjectContext:context];
    query.entity = entity;
    query.fetchLimit = 1;
    
    NSString *sql = [NSString stringWithFormat:@"%@==%@", @"sessionID", @"%@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql argumentArray:[NSArray arrayWithObject:sessionId]];
    query.predicate = predicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sessionID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [query setSortDescriptors:sortDescriptors];
    //[sortDescriptor release]; //todo: need check release
    
    Session *session = nil;
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:query error:&error];
    if (result == nil) {
        NSLog(@"Occur an error: %@, %@", error, error.userInfo);
	    abort();
    } else if ([result count] > 0) {
        session = [result objectAtIndex:0];
    }
    
    //[query release];//todo: need check release
    return session;
}

+ (NSMutableArray *) getAudienceBySessionId:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *query = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:AUDIENCEMODEL inManagedObjectContext:context];
    query.entity = entity;
    //query.fetchLimit = 100;
    
    NSString *sql = [NSString stringWithFormat:@"%@==%@", @"session.sessionID", @"%@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql argumentArray:[NSArray arrayWithObject:sessionId]];
    query.predicate = predicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:AudienceID ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [query setSortDescriptors:sortDescriptors];
    //[sortDescriptor release]; //todo: need check release
    
    NSMutableArray *aModels = nil;
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:query error:&error];
    if (result == nil) {
        NSLog(@"Occur an error: %@, %@", error, error.userInfo);
	    abort();
    } else if ([result count] > 0) {
        aModels = [result mutableCopy];
    }
    
    //[query release];//todo: need check release
    return aModels;
}

+ (Audience *) getAudienceByAudienceId:(NSNumber *)audienceID inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *query = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:AUDIENCEMODEL inManagedObjectContext:context];
    query.entity = entity;
    //query.fetchLimit = 100;
    
    NSString *sql = [NSString stringWithFormat:@"%@==%@", AudienceID, @"%@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql argumentArray:[NSArray arrayWithObject:audienceID]];
    query.predicate = predicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:AudienceID ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [query setSortDescriptors:sortDescriptors];
    //[sortDescriptor release]; //todo: need check release
    
    Audience *aModel = nil;
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:query error:&error];
    if (result == nil) {
        NSLog(@"Occur an error: %@, %@", error, error.userInfo);
	    abort();
    } else if ([result count] > 0) {
        aModel = [result objectAtIndex:0];
    }
    
    //[query release];//todo: need check release
    return aModel;
}

+(void) saveContext:(NSManagedObjectContext *)context{
    NSError *error;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end

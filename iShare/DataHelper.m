//
//  DataHelper.m
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

#import "DataHelper.h"
#import "Constants.h"
#define Default_DATE_STRING_FORMAT @"yyyy/MM/dd HH:mm"

@implementation DataHelper

+ (Audience *) scannedInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context{
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

+ (Audience *) keyInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context{
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

+ (NSString *) saveAudienceWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context{
  	Audience *aModel = [NSEntityDescription insertNewObjectForEntityForName:AUDIENCEMODEL inManagedObjectContext:context];

        NSString *temp= [[JSONDic objectForKey: @"sessionid"] stringValue];
        if([temp isEqualToString:@""]){
            return @"sessionId  can't be empty";
        }
    
    Session *sModel = [self getSessionForID:[NSNumber numberWithInteger:temp.integerValue] inContext:context];
    if (sModel == nil) {
        NSString *sValue = temp;
        return [NSString stringWithFormat:@"Can't find data where SessionId= %@", sValue];
    }else{
        aModel.session= sModel;
    }

	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *myNumber;
	temp= [[JSONDic objectForKey: @"userid"] stringValue];
	if([temp isEqualToString:@""]){
         	//without userId, this user is manual key in user.
         	aModel.lotteryIndicator = [NSNumber numberWithInt:0];
	}else{       
       		myNumber = [f numberFromString:temp];      
       		aModel.userID = myNumber;
       		aModel.lotteryIndicator = [NSNumber numberWithInt:1];
    	}
    	
   	aModel.checkinIndicator = @"Y";
   	aModel.attendTime = [NSDate date];
   	aModel.winIndicator = [NSNumber numberWithInt:0];

	temp= [JSONDic objectForKey: @"staffid"];
	if([temp isEqualToString:@""]){
        return @"staffid can't be empty";
	}else{
        //myNumber = [f numberFromString:temp];
        aModel.staffID = temp;
    }
 
	temp= [JSONDic objectForKey: @"staffname"];
	if([temp isEqualToString:@""]){
        return @"staffname can't be empty";
	}else{
        aModel.staffName = temp;
    }
  	[self saveContext:context];

   	return nil;
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
        sModel.uploadIndicator = NO;
        
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
        sModel.uploadIndicator = NO;
        [self saveContext:context];
    }
    
    return sModel;
}

+ (NSString *) saveSessionWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context{
    NSString *temp= [[JSONDic objectForKey: @"sessionid"] stringValue];
    if([temp isEqualToString:@""]){
        return @"sessionId can't be empty";
    }
    
    Session *sModel = [self getSessionForID:[NSNumber numberWithInteger:temp.integerValue] inContext:context];
    if (sModel != nil) {
        return [NSString stringWithFormat:@"the session with SessionId=%@ already exists! You can checkin the audiences.", temp];
    }else{
        sModel = [NSEntityDescription insertNewObjectForEntityForName:SESSIONMODEL inManagedObjectContext:context];
        sModel.sessionID = [NSNumber numberWithInteger:temp.integerValue];
    }

    temp= [JSONDic objectForKey: @"sessionname"];
    if([temp isEqualToString:@""]){
        return @"sessionname can't be empty";
    }
    else{
        sModel.sessionName = temp;
    }

    temp= [JSONDic objectForKey: @"sessiondesc"];
    if([temp isEqualToString:@""]){
        return @"sessiondesc can't be empty";
    }
    else{
        sModel.sessionDesc = temp;
    }
    
    temp= [JSONDic objectForKey: @"lecture"];
    if([temp isEqualToString:@""]){
        return @"lecture can't be empty";
    }
    else{
        sModel.lecturer = temp;
    }
    
    temp= [JSONDic objectForKey: @"location"];
    if([temp isEqualToString:@""]){
        return @"location can't be empty";
    }
    else{
        sModel.location = temp;
    }

    temp= [JSONDic objectForKey: @"deptName"];
    if([temp isEqualToString:@""]){
        return @"location can't be empty";
    }
    else{
        sModel.departmentName = temp;
    }

    sModel.scanedTime = [NSDate date];
    sModel.status = @"Open";
    sModel.uploadIndicator = NO;
    
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	[f setDateFormat:Default_DATE_STRING_FORMAT];
	NSDate *myDate;
	temp= [JSONDic objectForKey: @"starttime"];
	if([temp isEqualToString:@""]){
        return @"starttime can't be empty";
	}else{
        myDate = [f dateFromString:temp];
        sModel.startTime = myDate;
    }
    
	temp= [JSONDic objectForKey: @"endtime"];
	if([temp isEqualToString:@""]){
        return @"endtime can't be empty";
	}else{
        myDate = [f dateFromString:temp];
        sModel.startTime = myDate;
    }
    
  	[self saveContext:context];
    
   	return nil;
}

+ (NSError *) deleteSessionWithSessionId:(NSNumber *)sessionId withContext:(NSManagedObjectContext *) context{
    Session *sModel = [self getSessionForID:sessionId inContext:context];
    
    [context deleteObject:sModel];
    
    NSError *err= nil;
    [context save:&err];
    return err;
}

+ (NSError *) deleteSessionWithSession:(Session *)session withContext:(NSManagedObjectContext *) context{
    [context deleteObject:session];
    
    NSError *err= nil;
    [context save:&err];
    return err;
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

+ (NSMutableArray *) getAllSessionsWithStatus:(NSString *)status InContext:(NSManagedObjectContext *)context{
	NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:SESSIONMODEL];
	
	if(status != nil){
	    NSString *sql = [NSString stringWithFormat:@"%@==%@", @"status", @"%@"];
    	    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql argumentArray:[NSArray arrayWithObject:status]];
    	    request.predicate = predicate;
	}
    	
    	// Edit the sort key as appropriate.
    	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sessionID" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    	[request setSortDescriptors:sortDescriptors];
	
 	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];

	if (error != nil) {
   	    //Deal with failure
   	    NSLog(@"Occur an error: %@, %@", error, error.userInfo);
	    abort();
	}
	else {
   	    //Deal with success
        return [results mutableCopy];
	}
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

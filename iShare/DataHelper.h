//
//  DataHelper.h
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

#import "AudienceModel.h"
#import "SessionModel.h"

@interface DataHelper:NSObject

+ (Audience *) scannedInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSNumber *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context;

+ (Audience *) keyInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSNumber *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context;

+ (bool) updateAudienceWithAudienceId:(NSNumber *)aId andWinLottery:(NSNumber *)winStatus inContext:(NSManagedObjectContext *)context;

+ (NSString *) saveAudienceWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context;

+ (Session *) scannedInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andStatus:(NSString *)status inContext:(NSManagedObjectContext *)context;

+ (Session *) keyInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime inContext:(NSManagedObjectContext *)context;

+ (Session *) getSessionForID:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context;

+ (NSArray *) getAllSessionsWithStatus:(NSString *)status InContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *) getAudienceBySessionId:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context;

+ (Audience *) getAudienceByAudienceId:(NSNumber *)audienceID inContext:(NSManagedObjectContext *)context;

+(void) saveContext:(NSManagedObjectContext *)context;
@end

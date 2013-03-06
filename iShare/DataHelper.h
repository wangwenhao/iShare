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

+ (Audience *) scannedInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context;

+ (Audience *) keyInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffId andStaffName:(NSString *)staffName andUserId:(NSNumber *)userId inContext:(NSManagedObjectContext *)context;

+ (Audience *) keyInAudienceWithSessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffId inContext:(NSManagedObjectContext *)context;

+ (bool) updateAudienceWithAudienceId:(NSNumber *)aId andWinLottery:(NSNumber *)winStatus inContext:(NSManagedObjectContext *)context;

+ (void) updateAudienceWithAwardList:(NSMutableArray *)list;

+ (NSString *) saveAudienceWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context;

+ (Session *) scannedInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andStatus:(NSString *)status inContext:(NSManagedObjectContext *)context;

+ (Session *) keyInSessionWithSessionId:(NSNumber *)sessionId andSessionName:(NSString *)sessionName andSessionDesc:(NSString *)sDesc andLocation:(NSString *)location andDeptName:(NSString *)deptName andLecturer:(NSString *)lecturer andStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime inContext:(NSManagedObjectContext *)context;

+ (NSString *) saveSessionWithDict:(NSDictionary *)JSONDic withContext:(NSManagedObjectContext *)context;

+ (bool) updateSessionWithSessionId:(NSNumber *)sId andUploadStatus:(NSNumber *)uploadFlag;

+(void) updateSessionWithSessionList:(NSMutableOrderedSet *)sList andUploadStatus:(NSNumber *)uploadFlag;

+ (NSError *) deleteSessionWithSessionId:(NSNumber *)sessionId withContext:(NSManagedObjectContext *) context;

+ (NSError *) deleteSessionWithSession:(Session *)session withContext:(NSManagedObjectContext *) context;

+ (Session *) getSessionForID:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *) getAllSessionsWithStatus:(NSString *)status InContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *) getAudienceBySessionId:(NSNumber *)sessionId inContext:(NSManagedObjectContext *)context;

+ (Audience *) getAudienceByAudienceId:(NSNumber *)audienceID inContext:(NSManagedObjectContext *)context;

+ (Audience *) getAudienceBySessionId:(NSNumber *)sessionId andStaffId:(NSString *)staffID inContext:(NSManagedObjectContext *)context;

+(void) saveContext:(NSManagedObjectContext *)context;
@end

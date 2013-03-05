//
//  ConnectToIShare.m
//  iShare
//
//  Created by ncs on 3/4/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "ConnectToIShare.h"
#import "SessionModel.h"
#import "AudienceModel.h"
#import "JSONKit.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"

@implementation ConnectToIShare

@synthesize delegate = _delegate;

- (void)faildRequest:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(faildRequest:)]) {
        [self.delegate faildRequest:error];
    }
}

- (void)finishRequest:(id)result
{
    [self.delegate finishRequest:result];
    NSLog(@"%@", result);
}

- (void)uploadDataToIShare:(NSArray *) sessions
{
//    NSString *t = @"{\"status\": \"success\"}";
//    NSData *myData = [t dataUsingEncoding:NSUTF8StringEncoding];
//    id jsonResult = [myData objectFromJSONData];
//    NSLog(@"JSON: %@-%@", [jsonResult class], jsonResult);
//    
//    t = @"{'status': 'success'}";
//    myData = [t dataUsingEncoding:NSUTF8StringEncoding];
//    jsonResult = [myData objectFromJSONData];
//    NSLog(@"JSON: %@-%@", [jsonResult class], jsonResult);
    
    
    NSMutableArray *jsonList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *d = nil;
    for (Session *session in sessions) {
        for (Audience *audience in session.audiences) {
            d = [[NSMutableDictionary alloc] init];
            [d setObject:session.sessionID forKey:JSON_PARAM_SESSION_ID];
            [d setObject:audience.userID forKey:[NSString stringWithFormat:JSON_PARAM_USER_ID]];
            [jsonList addObject:d];
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, UPLOAD_URI]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"admin" forKey:PARAM_NAME_ACCOUNT_ID];
    [request setPostValue:@"admin" forKey:PARAM_NAME_ACCOUNT_PASSWORD];
    [request setPostValue:[jsonList JSONString] forKey:PARAM_NAME_JSON_LIST];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if(!error)
    {
        NSString *response = [request responseString];
    }
    
//    NSMutableArray *jsonList = [[NSMutableArray alloc] init];
//    
//    NSMutableDictionary *d = nil;
//    for (Session *session in sessions) {
//        for (Audience *audience in session.audiences) {
//            d = [[NSMutableDictionary alloc] init];
//            [d setObject:session.sessionID forKey:JSON_PARAM_SESSION_ID];
//            [d setObject:audience.userID forKey:[NSString stringWithFormat:JSON_PARAM_USER_ID]];
//            [jsonList addObject:d];
//        }
//    }
//    
//    InvokeServerModel *model = [[InvokeServerModel alloc] init];
//    NSString *params = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@", PARAM_NAME_ACCOUNT_ID, @"admin", PARAM_NAME_ACCOUNT_PASSWORD,
//                                    @"admin", PARAM_NAME_JSON_LIST, [jsonList JSONString]];
//    [model startInvoke:url withData:[params dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

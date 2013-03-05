//
//  InvokeServerModel.m
//  iShare
//
//  Created by ncs on 3/3/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "InvokeServerModel.h"
#import "JSONKit.h"


@implementation InvokeServerModel
@synthesize delegate = _delegate;
//
//- (void)dealloc
//{
//    [_delegate release];
//
//    [super dealloc];
//}

- (void) startInvoke:(NSString *)url
{
    [self startInvoke:url withData:nil];
}

- (void) startInvoke:(NSString *)url withData:(NSData *)reqData
{
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
    dispatch_async(myQueue, ^{
        NSData *myData = [[NSData alloc] initWithData:nil];
        NSString *entireURL = url;//[NSString stringWithFormat:@"%@/%@", SERVER_URL, url];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:entireURL]];
        [req setHTTPMethod:@"POST"];
        if(reqData)
        {
            [req setHTTPBody:reqData];
        }

        NSError *connectionErr = nil;
            
        myData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&connectionErr];
        dispatch_async(dispatch_get_main_queue(), ^{

            if(!connectionErr)
            {
                NSError *jsonErr = nil;
                NSLog(@"result: %@",[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding]);
                id jsonResult = [myData objectFromJSONData];//[NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:&jsonErr];
                NSLog(@"JSON: %@-%@", [jsonResult class], jsonResult);
                if (!jsonErr) {
                    [self.delegate finishRequest:jsonResult];
                } else {
                    NSLog(@"Occur an error: %@, %@", jsonErr, jsonErr.userInfo);
                    if ([self.delegate respondsToSelector:@selector(faildRequest:)])
                    {
                        [self.delegate faildRequest:jsonErr];
                    }
                }

            }
            else
            {
                NSLog(@"Occur an error: %@", connectionErr.userInfo);
                if([self.delegate respondsToSelector:@selector(faildRequest:)])
                {
                    [self.delegate faildRequest:connectionErr];
                }
            }
        });
    });
//    dispatch_release(myQueue);
    
}
@end

//
//  ConnectToIShare.h
//  iShare
//
//  Created by ncs on 3/4/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvokeServerModel.h"

@protocol ConnectToIShareDelegate <NSObject>

@required
- (void) finishRequest:(id)result;
@optional
- (void) faildRequest:(NSError *)error;

@end

@interface ConnectToIShare : NSObject <InvokeServerDelegate>

@property (nonatomic) id<ConnectToIShareDelegate> delegate;

- (void)uploadDataToIShare:(NSArray *)sessions;

@end

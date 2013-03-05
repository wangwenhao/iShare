//
//  InvokeServerModel.h
//  iShare
//
//  Created by ncs on 3/3/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InvokeServerDelegate <NSObject>
- (void) finishRequest:(id)result;
@optional
- (void) faildRequest:(NSError *)error;
@end

@interface InvokeServerModel : NSObject
{
    //    __weak id<InvokeServerDelegate> _delegate;
}

@property (nonatomic) id<InvokeServerDelegate> delegate;

- (void) startInvoke:(NSString *)url;
- (void) startInvoke:(NSString *)url withData:(NSData *)reqData;

@end

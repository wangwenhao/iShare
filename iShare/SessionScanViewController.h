//
//  SessionScanViewController.h
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZBarSDK.h"

@interface SessionScanViewController : UIViewController <ZBarReaderViewDelegate, UIAlertViewDelegate>
{
    SystemSoundID soundID;
}

@property (nonatomic, strong) ZBarReaderView *reader;

-(BOOL) isValidSessionJson:(NSDictionary *)JSONDic;

@end

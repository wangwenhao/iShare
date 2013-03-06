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
#import "SessionInfoPreviewViewController.h"

@interface SessionScanViewController : UIViewController <ZBarReaderViewDelegate, UIAlertViewDelegate>
{
    SystemSoundID soundID;
}

@property (nonatomic, strong) ZBarReaderView *reader;
@property (strong, nonatomic) IBOutlet UIView *scanView;

@property (strong, nonatomic) SessionInfoPreviewViewController *sessionPreViewController;

-(BOOL) isValidSessionJson:(NSDictionary *)JSONDic;
-(void) scanStart:(id) sender;
-(void) popViewController:(id) sender;

@end

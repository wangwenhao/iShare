//
//  CheckinScanViewController.h
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZBarSDK.h"
#import "KeyinStaffIDViewController.h"

@interface CheckinScanViewController : UIViewController <ZBarReaderViewDelegate, UIAlertViewDelegate>
{
    SystemSoundID soundID;
}

@property (nonatomic, strong) ZBarReaderView *reader;
@property (nonatomic, strong) KeyinStaffIDViewController *keyinStaffIDViewController;

@property (strong, nonatomic) IBOutlet UIView *scanView;

- (IBAction)KeyinStaffIDTapped:(id)sender;
-(BOOL) isValidTicketJson:(NSDictionary *)JSONDic;

-(void) scanStart:(id) sender;

@end

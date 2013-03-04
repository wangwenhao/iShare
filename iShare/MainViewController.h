//
//  MainViewController.h
//  iShare
//
//  Created by Wang Wen Hao on 2/19/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "SessionHistoryListViewController.h"
#import "SessionScanViewController.h"
#import "CheckinScanViewController.h"
#import "SettingViewController.h"
#import "SessionDetailsViewController.h"

@interface MainViewController : UIViewController <ZBarReaderDelegate>

@property (nonatomic, strong) SessionHistoryListViewController *sessionHistoryListViewController;
@property (nonatomic, strong) SessionScanViewController *sessionScanViewController;
@property (nonatomic, strong) SettingViewController *settingViewController;
@property (nonatomic, strong) CheckinScanViewController *checkinScanViewController;
@property (nonatomic, strong) SessionDetailsViewController *sessionDetaildViewController;

- (IBAction)checkinScanButtonTapped:(id)sender;
- (IBAction)sessionScanButtonTapped:(id)sender;
- (IBAction)sessionHistoryListButtonTapped:(id)sender;
- (void)settingButtonTapped:(id)sender;
- (IBAction)lotteryButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentSessionLabel;
@end

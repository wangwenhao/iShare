//
//  MainViewController.m
//  iShare
//
//  Created by Wang Wen Hao on 2/19/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sessionHistoryListViewController;
@synthesize sessionScanViewController;
@synthesize settingViewController;
@synthesize checkinScanViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkinScanButtonTapped:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kCurrentSession] == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还没选择当前课程，请扫描先" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = kNoSessionSeleted;
        [alert show];
        return;
    }
    checkinScanViewController = [[CheckinScanViewController alloc]initWithNibName:@"CheckinScanView" bundle:nil];
    [self.navigationController pushViewController:checkinScanViewController animated:YES];
}

- (IBAction)sessionScanButtonTapped:(id)sender {
    
    sessionScanViewController = [[SessionScanViewController alloc]initWithNibName:@"SessionScanView" bundle:nil];
    [self.navigationController pushViewController:sessionScanViewController animated:YES];
    
//    // ADD: present a barcode reader that scans from the camera feed
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    
//    for (UIView *temp in [reader.view subviews]) {
//        for (UIView *view in [temp subviews]) {
//            if ([view isKindOfClass:[UIToolbar class]]) {
//                for (UIView *button in [view subviews]) {
//                    if([button isKindOfClass:[UIButton class]] && ((UIButton *)button).buttonType == UIButtonTypeInfoLight)
//                    {
//                        [button removeFromSuperview];
//                    }
//                }
//            }
//        }
//    }
//    
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    // present and release the controller
//    [self presentViewController:reader animated:YES completion:^(void){}];
}

- (IBAction)sessionHistoryListButtonTapped:(id)sender {
    sessionHistoryListViewController = [[SessionHistoryListViewController alloc]initWithNibName:@"SessionHistoryListView" bundle:nil];
    [self.navigationController pushViewController:sessionHistoryListViewController animated:YES];
}

- (IBAction)settingButtonTapped:(id)sender {
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingView" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
}
@end

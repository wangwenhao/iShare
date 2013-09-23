//
//  MainViewController.m
//  iShare
//
//  Created by Wang Wen Hao on 2/19/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "DataHelper.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sessionHistoryListViewController;
@synthesize sessionScanViewController;
@synthesize settingViewController;
@synthesize checkinScanViewController;
@synthesize currentSessionLabel;
@synthesize sessionDetaildViewController;

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
    self.title = @"iShare";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(settingButtonTapped:)];
    self.navigationItem.rightBarButtonItem = settingButton;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    if ([defaults objectForKey:kCurrentSession] != nil) {
        NSNumber *sessionId = [NSNumber numberWithInteger:[[defaults objectForKey:kCurrentSession] integerValue]];
        self.currentSessionLabel.text = [[DataHelper getSessionForID:sessionId inContext:context] sessionName];
    } else {
        self.currentSessionLabel.text = @"还没有扫描课程信息";
    }
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
}

- (IBAction)sessionHistoryListButtonTapped:(id)sender {
    sessionHistoryListViewController = [[SessionHistoryListViewController alloc]initWithNibName:@"SessionHistoryListView" bundle:nil];
    [self.navigationController pushViewController:sessionHistoryListViewController animated:YES];
}

- (void)settingButtonTapped:(id)sender {
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingView" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (IBAction)lotteryButtonTapped:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kCurrentSession] == nil) {
        return;
    }
    NSNumber *sessionID = [NSNumber numberWithInteger:[[defaults objectForKey:kCurrentSession] integerValue]];
    sessionDetaildViewController = [[SessionDetailsViewController alloc]initWithSessionId:sessionID];
    [self.navigationController pushViewController:sessionDetaildViewController animated:YES];
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

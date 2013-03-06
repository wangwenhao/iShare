//
//  SessionInfoPreviewViewController.m
//  iShare
//
//  Created by Bryant on 2/28/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionInfoPreviewViewController.h"
#import "Constants.h"
#import "UILabel+VerticalAlign.h"
#import "AppDelegate.h"
#import "DataHelper.h"

@interface SessionInfoPreviewViewController ()

@end

@implementation SessionInfoPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionInfo:(NSDictionary *)sessionInfo
{
    self = [super init];
    if (self) {
        self.sessionDetails = sessionInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sessionNameLabel.text = [self.sessionDetails objectForKey:kSessionName];
    self.lectureLabel.text = [self.sessionDetails objectForKey:kSessionLecturer];
    self.locationLabel.text = [self.sessionDetails objectForKey:kSessionLocation];
    self.sessionDescLabel.text = [self.sessionDetails objectForKey:kSessionDesc];
    [self.sessionDescLabel alignTop];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:kDateFormat];
    
    NSDate *startTime = [dateFormater dateFromString:[self.sessionDetails objectForKey:kSessionStartTime]];
    if (startTime == nil) return;
    
    self.sessionTimeLabel.text = [dateFormater stringFromDate:startTime];
    
    NSDate *endTime = [dateFormater dateFromString:[self.sessionDetails objectForKey:kSessionEndTime]];
    if (endTime != nil)
    {
        NSDateFormatter *timeFormater = [[NSDateFormatter alloc]init];
        [timeFormater setDateFormat:@"HH:mm"];
        
        self.sessionTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormater stringFromDate:startTime], [timeFormater stringFromDate:endTime]];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveCurrentSession:(id)sender
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSString *errMsg = [DataHelper saveSessionWithDict:self.sessionDetails withContext:context];
    if (errMsg != nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"数据错误:%@",errMsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.sessionDetails objectForKey:kSessionID] forKey:kCurrentSession];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPopViewControllerNofitication object:nil];
    }];
}

- (IBAction)rescan:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotification:[NSNotification notificationWithName:kSessionScanStartNotification object:nil]];
    }];
}
@end

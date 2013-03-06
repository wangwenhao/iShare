//
//  CheckinScanViewController.m
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "CheckinScanViewController.h"
#import "JSONKit.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DataHelper.h"

@interface CheckinScanViewController ()

@end

@implementation CheckinScanViewController
@synthesize reader;
@synthesize scanView;
@synthesize keyinStaffIDViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [reader stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫描";
    
    // Do any additional setup after loading the view from its nib.
    ZBarImageScanner *scanner = [[ZBarImageScanner alloc]init];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    reader = [[ZBarReaderView alloc]initWithImageScanner:scanner];
    reader.frame = CGRectMake(0.0f, 0.0f, scanView.frame.size.width, scanView.frame.size.height);
    reader.torchMode = NO;
    reader.readerDelegate = self;
    
    [scanView addSubview:reader];
    
    [reader start];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(scanStart:) name:kCheckinScanStartNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([(NSNumber *)[defaults objectForKey:kEnabledSound] boolValue]) {
        NSURL *filePath = [[NSBundle mainBundle]URLForResource:@"da" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID(CFBridgingRetain(filePath), &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
    if ([(NSNumber *)[defaults objectForKey:kEnabledVibrate] boolValue]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        [reader stop];
        
        NSData *jsonData = [symbol.data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        
        if (![self isValidTicketJson:resultDic]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请扫描正确的二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = kAddAudienceError;
            [alert show];
            return;
        }
        
        NSLog(@"%@", resultDic);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:kCurrentSession] integerValue] != [[resultDic objectForKey:kTicketSessionID] integerValue]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"课程与当前课程不符，你走错教室了吗？" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kSessionMismatch;
            [alert show];
            return;
        }
        
        NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSString *errMsg = [DataHelper saveAudienceWithDict:resultDic withContext:managedObjectContext];
        
        if (errMsg != nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"数据错误:%@",errMsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [reader start];
        
        break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == kSessionMismatch) {
        [reader start];
//    }
}

- (IBAction)KeyinStaffIDTapped:(id)sender {
    keyinStaffIDViewController = [[KeyinStaffIDViewController alloc]initWithNibName:@"KeyinStaffIDView" bundle:nil];
    [self presentViewController:keyinStaffIDViewController animated:YES completion:^{}];
}

-(BOOL)isValidTicketJson:(NSDictionary *)JSONDic
{
    NSArray *key = [JSONDic allKeys];
    if ([key count] != 5) return NO;
    if (![key containsObject:kTicketUserID]) return NO;
    if (![key containsObject:kTicketStaffID]) return NO;
    if (![key containsObject:kTicketUserName]) return NO;
    if (![key containsObject:kTicketSessionID]) return NO;
    if (![key containsObject:kTicketSessionName]) return NO;
    
    return YES;
}

-(void)scanStart:(id)sender
{
    [reader start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

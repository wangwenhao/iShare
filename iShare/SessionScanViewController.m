//
//  SessionScanViewController.m
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionScanViewController.h"
#import "JSONKit.h"
#import "DataHelper.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface SessionScanViewController ()

@end

@implementation SessionScanViewController
@synthesize reader;
@synthesize scanView;
@synthesize sessionPreViewController;

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
    self.title = @"选课";
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
    [notificationCenter addObserver:self selector:@selector(scanStart:) name:kSessionScanStartNotification object:nil];
    
    
    [notificationCenter addObserver:self selector:@selector(popViewController:) name:kPopViewControllerNofitication object:nil];
}

-(void)scanStart:(id)sender
{
    [reader start];
}

-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    // read the firse symbol
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        [reader stop];
        
        //TODO: Hardcode for testing
//        NSString *jsonString = @"{\"sessionid\":1,\"sessionname\":\"session 1\",\"sessiondesc\":\"this session is for testing\",\"starttime\":\"2013/12/25 13:00\",\"endtime\":\"2013/12/25 15:00\", \"lecture\":\"peter\",\"location\":\"7F Cambridge\",\"deptName\":\"34103001\"}";
        NSString *jsonString = symbol.data;
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        
        if (![self isValidSessionJson:resultDic]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请扫描正确的二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"%@", resultDic);
                
        sessionPreViewController = [[SessionInfoPreviewViewController alloc]initWithSessionInfo:resultDic];
        [self presentViewController: sessionPreViewController animated: YES completion:^{}];
        break;
    }
}

-(BOOL)isValidSessionJson:(NSDictionary *)JSONDic
{
    NSArray *key = [JSONDic allKeys];
    if ([key count] != 8) return NO;
    if (![key containsObject:kSessionID]) return NO;
    if (![key containsObject:kSessionName]) return NO;
    if (![key containsObject:kSessionDesc]) return NO;
    if (![key containsObject:kSessionStartTime]) return NO;
    if (![key containsObject:kSessionEndTime]) return NO;
    if (![key containsObject:kSessionLecturer]) return NO;
    if (![key containsObject:kSessionLocation]) return NO;
    if (![key containsObject:kSessionDepartment]) return NO;

    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [reader start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

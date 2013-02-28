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
    reader.readerDelegate = self;
    
    [scanView addSubview:reader];
    
    [reader start];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(scanStart:) name:@"SessionScanStart" object:nil];
}

-(void)scanStart:(id)sender
{
    [reader start];
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([(NSNumber *)[defaults objectForKey:@"enabled_sound"] boolValue]) {
        NSURL *filePath = [[NSBundle mainBundle]URLForResource:@"da" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID(CFBridgingRetain(filePath), &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
    if ([(NSNumber *)[defaults objectForKey:@"enabled_vibrate"] boolValue]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    // read the firse symbol
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        [reader stop];
        
        //TODO: Hardcode for testing
        NSString *jsonString = @"{\"sessionid\":1,\"sessionname\":\"session 1\",\"sessiondesc\":\"this session is for testing\",\"starttime\":\"2013/12/25 13:00\",\"endtime\":\"2013/12/25 15:00\", \"lecture\":\"peter\",\"location\":\"7F Cambridge\",\"deptName\":\"34103001\"}";
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        
        if (![self isValidSessionJson:resultDic]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请扫描正确的二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"%@", resultDic);
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSString *errMsg = [DataHelper saveSessionWithDict:resultDic withContext:context];
        if (errMsg != nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"数据错误:%@",errMsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        sessionPreViewController = [[SessionInfoPreviewViewController alloc]initWithSessionInfo:resultDic];
        [self presentViewController: sessionPreViewController animated: YES completion:^{}];
        break;
    }
}

-(BOOL)isValidSessionJson:(NSDictionary *)JSONDic
{
    NSArray *key = [JSONDic allKeys];
    if ([key count] != 8) return NO;
    if (![key containsObject:@"sessionid"]) return NO;
    if (![key containsObject:@"sessionname"]) return NO;
    if (![key containsObject:@"sessiondesc"]) return NO;
    if (![key containsObject:@"starttime"]) return NO;
    if (![key containsObject:@"endtime"]) return NO;
    if (![key containsObject:@"lecture"]) return NO;
    if (![key containsObject:@"location"]) return NO;
    if (![key containsObject:@"deptName"]) return NO;

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

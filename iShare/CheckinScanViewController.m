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

@interface CheckinScanViewController ()

@end

@implementation CheckinScanViewController
@synthesize reader;

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
    
    reader.readerDelegate = self;
    
    [self.view addSubview:reader];
    
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
    
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        [reader stop];
        
        //TODO: Hardcode for testing
        NSString *jsonString = @"{\"sessionid\":1,\"userid\":123,\"staffid\":\"300530\",\"staffname\":\"Wang Wen Hao\"}";
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        
        if (![self isValidTicketJson:resultDic]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请扫描正确的二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }        
        
        NSLog(@"%@", resultDic);
        
        //TODO: save the ticket info.
        NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSString *errMsg = [DataHelper saveAudienceWithDict:resultDic withContext:managedObjectContext];
        
        if (errMsg != nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"数据错误:%@",errMsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }     
        
        break;
    }
}

-(BOOL)isValidTicketJson:(NSDictionary *)JSONDic
{
    NSArray *key = [JSONDic allKeys];
    if ([key count] != 4) return NO;
    if (![key containsObject:@"sessionid"]) return NO;
    if (![key containsObject:@"userid"]) return NO;
    if (![key containsObject:@"staffid"]) return NO;
    if (![key containsObject:@"staffname"]) return NO;
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CheckinScanViewController.m
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "CheckinScanViewController.h"

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
    NSURL *filePath = [[NSBundle mainBundle]URLForResource:@"da" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(filePath), &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        [reader stop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

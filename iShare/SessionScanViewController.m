//
//  SessionScanViewController.m
//  iShare
//
//  Created by Bryant on 2/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionScanViewController.h"

@interface SessionScanViewController ()

@end

@implementation SessionScanViewController
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
    self.title = @"选课";
    // Do any additional setup after loading the view from its nib.
    
    // ADD: present a barcode reader that scans from the camera feed
    //ZBarReaderViewController *reader = [ZBarReaderViewController new];
    ZBarImageScanner *scanner = [[ZBarImageScanner alloc]init];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

    reader = [[ZBarReaderView alloc]initWithImageScanner:scanner];
    
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
    
    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
//    ZBarImageScanner *scanner = reader.scanner;
    
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
    
    [self.view addSubview:reader];
    
    [reader start];
    // present and release the controller
    //[self presentViewController:reader animated:YES completion:^(void){}];
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

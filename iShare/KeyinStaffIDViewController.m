//
//  KeyinStaffIDViewController.m
//  iShare
//
//  Created by Bryant on 3/3/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "KeyinStaffIDViewController.h"
#import "Constants.h"
#import "DataHelper.h"
#import "AppDelegate.h"

@interface KeyinStaffIDViewController ()

@end

@implementation KeyinStaffIDViewController
@synthesize staffID = _staffID;

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
    self.title = @"手动输入员工号";
    [_staffID becomeFirstResponder];
    _staffID.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNoRegistedStaff:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *sessionID = [NSNumber numberWithInteger:[[defaults objectForKey:kCurrentSession] integerValue]];
    NSString *staffID = _staffID.text;
    //TODO: save the ticket info.
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [DataHelper keyInAudienceWithSessionId:sessionID andStaffId:staffID inContext:context];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotification:[NSNotification notificationWithName:kCheckinScanStartNotification object:nil]];
    }];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 6 || returnKey;
}

@end

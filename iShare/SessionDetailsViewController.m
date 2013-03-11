//
//  SessionDetailsViewController.m
//  iShare
//
//  Created by Bryant on 3/4/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionDetailsViewController.h"
#import "DataHelper.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface SessionDetailsViewController ()

@end

@implementation SessionDetailsViewController
@synthesize waitingAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSessionId:(NSNumber *)sid
{
    self = [super init];
    if (self) {
        sessionId = sid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"课程信息";
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    session = [DataHelper getSessionForID:sessionId inContext:context];
    
    self.sessionNameLabel.text = session.sessionName;
    self.sessionLecturerLabel.text = session.lecturer;
    self.sessionLocationLabel.text = session.location;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:kDateFormat];
    
    if (session.startTime != nil) {
        self.sessionTimeLabel.text = [dateFormater stringFromDate:session.startTime];
        if (session.endTime != nil)
        {
            NSDateFormatter *timeFormater = [[NSDateFormatter alloc]init];
            [timeFormater setDateFormat:@"HH:mm"];
            
            self.sessionTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormater stringFromDate:session.startTime], [timeFormater stringFromDate:session.endTime]];
            
        }
    }
    
    currentIndex = nil;
    
    NSSet *audiencesSet = session.audiences;//I have inserted 2 audiences, this operation only returns 1 audiences.
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"attendTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    audiences = [audiencesSet sortedArrayUsingDescriptors:sortDescriptors];
    
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadData:)];
    self.navigationItem.rightBarButtonItem = uploadButton;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        
         waitingAlert = [[UIAlertView alloc]initWithTitle:@"请稍等" message:@"\n\n\n\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [waitingAlert show];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = CGPointMake(CGRectGetMidX(waitingAlert.bounds), CGRectGetMidY(waitingAlert.bounds));
        [activity startAnimating];
        
        [waitingAlert addSubview:activity];
        
        [self performSelector:@selector(getLottery:) withObject:nil afterDelay:5];
    }
}

-(void)getLottery:(id)sender
{
    int awardCount = [[NSUserDefaults standardUserDefaults] integerForKey:kSliderAwardCount];
    NSMutableArray *awardList = [[NSMutableArray alloc]init];
    
    int totalMember = 0;
    for (Audience *obj in audiences) {
        if ([obj.lotteryIndicator boolValue] == YES) {
            totalMember++;
        }
    }
    
    while (awardList.count < awardCount) {
        if (awardList.count == totalMember) break;
        Audience *obj;
        int r = arc4random() % [audiences count];
        if(r < [audiences count])
        {
            obj = [audiences objectAtIndex:r];
            if ([obj.lotteryIndicator boolValue] == YES && ![awardList containsObject:obj]) {
                [awardList addObject:obj];
            }
        }
    }
    
    NSString *result = @"";
    
    for (Audience *obj in awardList) {
        result = [NSString stringWithFormat:@"%@\n%@ - %@", result, obj.staffID, obj.staffName];
    }
    
    [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //TODO: Need to save to database
    [DataHelper updateAudienceWithAwardList:awardList];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获奖名单" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

-(void)uploadData:(id)sender
{
    if ([session.uploadIndicator boolValue] == YES) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此课程信息已经上传过了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    waitingAlert = [[UIAlertView alloc]initWithTitle:@"请稍等" message:@"\n\n\n\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [waitingAlert show];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(CGRectGetMidX(waitingAlert.bounds), CGRectGetMidY(waitingAlert.bounds));
    [activity startAnimating];
    
    [waitingAlert addSubview:activity];
    
    [self performSelector:@selector(doUploadData) withObject:nil afterDelay:1];
}

-(void)doUploadData
{
    NSMutableArray *jsonList = [[NSMutableArray alloc] init];
    NSMutableOrderedSet *sessionIdList = [[NSMutableOrderedSet alloc]init];
    NSMutableDictionary *d = nil;
    
    for (Audience *audience in session.audiences) {
        d = [[NSMutableDictionary alloc] init];
        [d setObject:session.sessionID forKey:JSON_PARAM_SESSION_ID];
        [d setObject:audience.staffID forKey:[NSString stringWithFormat:JSON_PARAM_USER_ID]];
        [jsonList addObject:d];
        [sessionIdList addObject:session];
    }
    
//    NSString *testString = @"[{\"userId\":\"1\",\"sessionId\":\"2\"},{\"userId\":\"2\",\"sessionId\":\"2\"},{\"userId\":\"3\",\"sessionId\":\"2\"}]";
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kServerSetting]];
    //[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, UPLOAD_URI]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"admin" forKey:PARAM_NAME_ACCOUNT_ID];
    [request setPostValue:@"admin" forKey:PARAM_NAME_ACCOUNT_PASSWORD];
    [request setPostValue:[jsonList JSONString] forKey:PARAM_NAME_JSON_LIST];
//    [request setPostValue:testString forKey:PARAM_NAME_JSON_LIST];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *message = @"";
    
    if(!error)
    {
        NSString *response = [[request responseString] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
//        NSString *successResult = @"{\"status\": \"success\", \"data\": [{\"staffId\":\"300999\",\"sessionId\":\"2\"},{\"staffId\":\"300888\",\"sessionId\":\"2\"},{\"staffId\":\"300777\",\"sessionId\":\"2\"}]}";
//        NSString *failureResult = @"{\"status\": \"failure\", \"data\": [{\"staffId\":\"300999\",\"sessionId\":\"2\"},{\"staffId\":\"300888\",\"sessionId\":\"2\"},{\"staffId\":\"300777\",\"sessionId\":\"2\"}], \"error\": \"invalid syntax (<string>, line 1)\"}";
        
        NSData *resultData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [resultData objectFromJSONData];
        
        if ([[resultDic objectForKey:@"status"] isEqualToString:@"success"]) {
            [DataHelper updateSessionWithSessionList:sessionIdList andUploadStatus:[NSNumber numberWithInt:1]];
            message = @"上传成功";
        } else {
            if ([[resultDic allKeys]containsObject:@"error"]) {
                message = [resultDic objectForKey:@"error"];
            }
        }
    } else {
        message = error.localizedDescription;
    }
    
    [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        if(currentIndex != nil
//           && [currentIndex compare:indexPath] == NSOrderedSame){
//            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//            label.tag = 1;
//            label.lineBreakMode = NSLineBreakByWordWrapping;
//            label.highlightedTextColor = [UIColor whiteColor];
//            label.numberOfLines = 0;
//            label.opaque = NO;
//            label.backgroundColor = [UIColor clearColor];
//            [cell.contentView addSubview:label];
//
//        }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        }

    }
    
    // Configure the cell...
    Audience *audience = (Audience *)[audiences objectAtIndex:indexPath.row];
//    if(currentIndex != nil
//       && [currentIndex compare:indexPath] == NSOrderedSame){
//            UILabel *label = (UILabel *)[cell viewWithTag:1];
//            CGRect cellFrame = [cell frame];
//            cellFrame.origin = CGPointMake(0, 0);
//            NSDateFormatter *df = [[NSDateFormatter alloc] init];
//            [df setDateFormat:kDateFormat];
//            NSString *msg;
//            if([audience.winIndicator isEqualToNumber:[NSNumber numberWithInt:1]]){
//                    msg = @"This dude is lucky and won the lottery!";
//            }else{
//                    msg = @"This dude is unlucky!";
//            }
//        
//            label.text = [NSString stringWithFormat:@"Staff Id:%@\nStaff Name:%@\nAttended at:%@\nUser ID:%@\nRemarks:%@",audience.staffID,audience.staffName,[df stringFromDate:audience.attendTime],audience.userID,msg];
//            //NSLog(@"Label Text:%@",label.text);
//            CGRect rect = CGRectInset(cellFrame, 2, 2);
//            label.frame = rect;
//            [label sizeToFit];
//        
//            if (label.frame.size.height > 46) {
//                cellFrame.size.height = 50 + label.frame.size.height - 46;
//            }
//            else {
//                cellFrame.size.height = 50;
//            }
//            [cell setFrame:cellFrame];
//        
//    }
//    else{
        cell.textLabel.text = audience.staffID;
        cell.detailTextLabel.text = audience.staffName;
//    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return audiences.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if(currentIndex != nil && [currentIndex compare:indexPath] == NSOrderedSame){
//        return;
//    }
    currentIndex = indexPath;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentIndex] withRowAnimation:UITableViewRowAnimationNone];
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(currentIndex != nil
//       && [currentIndex compare:indexPath] == NSOrderedSame){
//        return DEFAULT_CELL_HEIGHT*2;
//    }
    return DEFAULT_CELL_HEIGHT;
}

@end

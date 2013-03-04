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

@interface SessionDetailsViewController ()

@end

@implementation SessionDetailsViewController

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
    
    NSSet *audiencesSet = session.audiences;
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"attendTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    audiences = [audiencesSet sortedArrayUsingDescriptors:sortDescriptors];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Audience *aModel = (Audience *)[audiences objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@    %@",aModel.staffID,aModel.staffName];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setMinimumScaleFactor:MIN_SCALE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        
        NSDateFormatter *timeFormater = [[NSDateFormatter alloc]init];
        [timeFormater setDateFormat:kDateFormat];
        
        Audience *aModel = (Audience *)[audiences objectAtIndex:indexPath.row];
        if([aModel.winIndicator isEqualToNumber:[NSNumber numberWithInt:1] ]){
        label.text =[NSString stringWithFormat:@"%@    %@\n%@   %@\n%@",aModel.staffID,aModel.staffName,@"checked in: @",[timeFormater stringFromDate:aModel.attendTime],@"This dude is very lucky and has won the lottery!"];
        }else{
         label.text =[NSString stringWithFormat:@"%@    %@\n%@   %@\n%@",aModel.staffID,aModel.staffName,@"checked in: @",[timeFormater stringFromDate:aModel.attendTime],@"This dude is unlucky."];
        }
        
        [[cell contentView] addSubview:label];
    }

}

@end

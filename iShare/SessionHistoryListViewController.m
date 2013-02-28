//
//  SessionHistoryListViewController.m
//  iShare
//
//  Created by Bryant on 2/21/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionHistoryListViewController.h"
#import "AppDelegate.h"
#import "DataHelper.h"

@interface SessionHistoryListViewController ()

@end

@implementation SessionHistoryListViewController

@synthesize session;
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史";

    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After managedObjectContext: %@",  _managedObjectContext);
    }
    
    session = [DataHelper getAllSessionsWithStatus:nil InContext:_managedObjectContext];
    //Session *sModel1 = [DataHelper scannedInSessionWithSessionId:[NSNumber numberWithInt:1] andSessionName:@"Session A" andSessionDesc:@"Test Session A." andLocation:@"7F Cambridge" andDeptName:@"DS1" andLecturer:@"Professor A" andStartTime:[NSDate date] andEndTime:[NSDate dateWithTimeIntervalSinceNow:20000.0] andStatus:@"Open" inContext:_managedObjectContext];    
    //Session *sModel2 = [DataHelper scannedInSessionWithSessionId:[NSNumber numberWithInt:2] andSessionName:@"Session B" andSessionDesc:@"Test Session B." andLocation:@"8F Oxford" andDeptName:@"HR" andLecturer:@"Professor B" andStartTime:[NSDate date] andEndTime:[NSDate dateWithTimeIntervalSinceNow:12000.0] andStatus:@"Open" inContext:_managedObjectContext];    
    //Session *sModel3 = [DataHelper scannedInSessionWithSessionId:[NSNumber numberWithInt:3] andSessionName:@"Session C" andSessionDesc:@"Test Session C." andLocation:@"9F Havard" andDeptName:@"34103001" andLecturer:@"Professor C"  andStartTime:[NSDate date] andEndTime:[NSDate dateWithTimeIntervalSinceNow:50000.0] andStatus:@"Open" inContext:_managedObjectContext];
    
    //session = [[NSArray alloc]initWithObjects:sModel1,sModel2,sModel3, nil];
    //session = [[NSArray alloc]initWithObjects:@"Session1", @"Session2", @"Session3", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return session.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [(Session *)[session objectAtIndex:indexPath.row] sessionName];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

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
#define CONFIRM_DELETION 3

@interface SessionHistoryListViewController ()

@end

@implementation SessionHistoryListViewController

@synthesize session;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailsViewController;

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
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Session *sModel =(Session *)[session objectAtIndex:indexPath.row];
        if(sModel.uploadIndicator){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"该课程还未上传数据，如果删除，数据将无法恢复。您确认要删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"删除",nil];
            alert.tag = CONFIRM_DELETION;
            [alert show];

        }
        
        NSError *err =[DataHelper deleteSessionWithSession:sModel withContext:_managedObjectContext];
        if(err == nil){
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSLog(@"Error occured:%@,%@",err, err.userInfo);
            abort();
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alert.tag) {
        case CONFIRM_DELETION:
            switch (buttonIndex) {
                case 0://cancel
                    
                    break;
                case 1://delete
                    break;
                default:
                    NSLog(@"SessionHistoryListViewController.alertView: clickedButtonAtIndex. Unknown button.");
                    break;
            }
            break;
            
        default:
            NSLog(@"SessionHistoryListViewController.alertView: clickedButtonAtIndex. Unknown alert Type.");
            break;
    }
}


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

    NSNumber *sessionId = [(Session *)[session objectAtIndex:indexPath.row] sessionID];
    detailsViewController = [[SessionDetailsViewController alloc]initWithSessionId:sessionId];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

@end

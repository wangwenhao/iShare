//
//  MySessionViewController.m
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "MySessionViewController.h"
#import "SessionViewCell.h"

@interface MySessionViewController ()

@end

@implementation MySessionViewController
@synthesize mySession = _mySession;
@synthesize sessionPreviewController = _sessionPreviewController;

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
    
    self.title = @"我的课程";
    
    NSDictionary *session1 = [NSDictionary dictionaryWithObjectsAndKeys:@".NET MVC4", @"SessionName", @"张三", @"Lecturer", @"2013-9-18 13:30", @"SessionTime", nil];
    NSDictionary *session3 = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"SessionName", @"王五", @"Lecturer", @"2013-9-18 13:30", @"SessionTime", nil];
    _mySession = [NSArray arrayWithObjects: session1, session3, nil];

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
    return _mySession.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SessionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SessionViewCell" owner:self options:nil] lastObject];
    }
    
    // Configure the cell...
    
    cell.sessionName.text = [((NSDictionary *)[_mySession objectAtIndex:indexPath.row]) objectForKey:@"SessionName"];
    cell.lecturer.text = [((NSDictionary *)[_mySession objectAtIndex:indexPath.row]) objectForKey:@"Lecturer"];
    cell.sessionTime.text = [((NSDictionary *)[_mySession objectAtIndex:indexPath.row]) objectForKey:@"SessionTime"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
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
    
    _sessionPreviewController = [[SessionPreviewController alloc]initWithNibName:@"SessionPreviewController" bundle:nil];
    [self.navigationController pushViewController:_sessionPreviewController animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

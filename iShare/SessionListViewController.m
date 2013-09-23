//
//  SessionListViewController.m
//  iShare
//
//  Created by Bryant on 9/17/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "SessionListViewController.h"
#import "SessionViewCell.h"
#import "JSONKit.h"
#import "TempJson.h"

@interface SessionListViewController ()

@end

@implementation SessionListViewController
@synthesize sessionList = _sessionList;
@synthesize mainViewController = _mainViewController;
@synthesize mySessionViewController = _mySessionViewController;
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
    
    UIBarButtonItem *adminButton = [[UIBarButtonItem  alloc]initWithTitle:@"我是管理猿" style:UIBarButtonItemStyleBordered target:self action:@selector(adminLogin)];
    self.navigationItem.leftBarButtonItem = adminButton;
    
    UIBarButtonItem *selectedSession = [[UIBarButtonItem alloc]initWithTitle:@"我的课程" style:UIBarButtonItemStyleBordered target:self action:@selector(showMySession)];
    self.navigationItem.rightBarButtonItem = selectedSession;
    
    //TODO: Update the Session List with Service save the session infomation into local DB.
    
    [self loadSessionList];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)adminLogin
{
    UIAlertView *adminLoginView = [[UIAlertView alloc]initWithTitle:@"管理员登陆" message:@"请输入管理员用户密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登陆", nil];
    [adminLoginView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [adminLoginView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        _mainViewController = [[MainViewController alloc]initWithNibName:@"MainView" bundle:nil];
        [self.navigationController pushViewController:_mainViewController animated:YES];
    }
}

-(void)showMySession
{
    _mySessionViewController = [[MySessionViewController alloc]initWithNibName:@"MySessionViewController" bundle:nil];
    [self.navigationController pushViewController:_mySessionViewController animated:YES];
}

- (void)loadSessionList
{
    
    //Hardcode here.
    
    NSString *jsonString = SessionListJson;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    _sessionList = [jsonData objectFromJSONData];
    
//    NSDictionary *session1 = [NSDictionary dictionaryWithObjectsAndKeys:@".NET MVC4", @"SessionName", @"张三", @"Lecturer", @"2013-9-18 13:30", @"SessionTime", nil];
//    NSDictionary *session2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Java", @"SessionName", @"李四", @"Lecturer", @"2013-9-18 13:30", @"SessionTime", nil];
//    NSDictionary *session3 = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"SessionName", @"王五", @"Lecturer", @"2013-9-18 13:30", @"SessionTime", nil];
//    _sessionList = [NSArray arrayWithObjects: session1, session2, session3, nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _sessionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SessionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SessionViewCell" owner:self options:nil] lastObject];
        
        //[[SessionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.sessionName.text = [[_sessionList objectAtIndex:indexPath.row] objectForKey:@"sessionname"];
    cell.lecturer.text = [[_sessionList objectAtIndex:indexPath.row] objectForKey:@"lecture"];
    cell.sessionTime.text = [[_sessionList objectAtIndex:indexPath.row] objectForKey:@"starttime"];
    
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

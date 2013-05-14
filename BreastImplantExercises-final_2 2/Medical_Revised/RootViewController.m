//
//  RootViewController.m
//  Medical
//
//  Created by Askone on 3/14/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "RootViewController.h"
#import "RapidReturnController.h"
#import "BreastMassageController.h"
#import "MTPopupWindow.h"
#import "MKLocalNotificationsScheduler.h"
#import "EulaViewController.h"
@implementation RootViewController
@synthesize DisclaimerView = _DisclaimerView;

#pragma mark -
#pragma mark View lifecycle

-(IBAction)pushButton:(id)sender{
    
	if ([sender isEqual:button1]) {
		
		RapidReturnController * rController = [[RapidReturnController alloc] initWithNibName:@"RapidReturnController" bundle:nil];
		[self.navigationController pushViewController:rController animated:YES];
		[rController release];
        
	}
    else if ([sender isEqual:button2]) {
		BreastMassageController *bController = [[[BreastMassageController alloc] initWithNibName:@"BreastMassageController" bundle:nil] autorelease];
        [self.navigationController pushViewController:bController animated:YES];
	}
}


- (void)viewDidLoad {
//    int hour = 04;
//    int minutes = 30;
//    int day = 24;
//    int month = 1;
//    int year = 2013;
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    
//    [components setDay:day];
//    [components setMonth:month];
//    [components setYear:year];
//    [components setMinute:minutes];
//    [components setHour:hour];
//    
//    NSDate *myNewDate = [calendar dateFromComponents:components];
//    [components release];
//    [calendar release];
//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:60*3];
//    //NSCalendar *repeatInterval = NSHourCalendarUnit;
//
//    [[MKLocalNotificationsScheduler sharedInstance] scheduleNotificationOn:myNewDate
//                                                                      text:@"Default scheduler for phase 1"
//                                                                    action:@"View"
//                                                                     sound:nil
//                                                               launchImage:nil
//                                                                   andInfo:nil];
//   
////
//    [[MKLocalNotificationsScheduler sharedInstance] schedulePhaseTwoNotificationOn:fireDate
//                                                                      text:@"Default scheduler for phase 2"
//                                                                    action:@"View"
//                                                                     sound:nil
//                                                               launchImage:nil
//                                                                   andInfo:nil];
    

	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Home"
									  style:UIBarButtonItemStyleBordered
									 target:nil
									 action:nil] autorelease];
	
	//self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1]localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Placik Protocol", @"");
	[label sizeToFit];
	
    UIBarButtonItem *disc = [[UIBarButtonItem alloc] initWithTitle:@"Disclaimer" style:UIBarButtonItemStylePlain target:self action:@selector(ViewDisclaimer:)];
    self.navigationItem.rightBarButtonItem= disc;
    
	[super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstTime = [userDefaults boolForKey:@"FirstTime"];
    //    [userDefaults setBool:YES forKey:@"FirstTime"];
    //    [userDefaults synchronize];
    if (!firstTime) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil) return;
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *local in array)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:local];
        }
        EulaViewController *eulaViewController = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        [self presentModalViewController:eulaViewController animated:NO];
        self.helpView.hidden = NO;
        UIBarButtonItem *disc = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideHelpView)];
        self.navigationItem.rightBarButtonItem= disc;
    }
    else
    {
        int i = 0;
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *local in array)
        {
            NSString *alertType = [local.userInfo objectForKey:KAlertType];
            if (alertType) {
                i++;
            }
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    }
}

- (void)hideHelpView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"FirstTime"];
    [userDefaults synchronize];
    self.helpView.hidden = YES;
    UIBarButtonItem *disc = [[UIBarButtonItem alloc] initWithTitle:@"Disclaimer" style:UIBarButtonItemStylePlain target:self action:@selector(ViewDisclaimer:)];
    self.navigationItem.rightBarButtonItem= disc;
}
-(void)ViewDisclaimer:(id)sender {

    if (!isShowDisclaim) {
        isShowDisclaim = YES;
        [MTPopupWindow showWindowWithHTMLFile:@"Terms of User" insideView:self.view viewController:self];
    }
    else
    {
        [[MTPopupWindow sharedInstance] closePopupWindow];
    }
    
}

- (void)didClosePopupWindow
{
    isShowDisclaim = NO;
}

-(void)closePopupWindow{

    [self.DisclaimerView removeFromSuperview];
}
/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setHelpView:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_helpView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end


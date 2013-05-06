//
//  RapidReturnController.m
//  Medical
//
//  Created by Askone on 3/14/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "AppDelegate.h"
#import "RapidReturnController.h"
#import "MTPopupWindow.h"
#import "Exercise.h"
#import "NewActivityController.h"
#import "DefaultExerciseController.h"
#import "CustomExerciseController.h"
#import "AppManager.h"


@implementation RapidReturnController
@synthesize videoView, execeriseDetails, settingsView;
@synthesize tableView = _tableView;
@synthesize phaseView;
@synthesize exerciseArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    
    [super viewDidLoad];
	//[self embedYouTube:@"" frame:CGRectMake(151, 87, 156, 100)];
    //[self embedYouTube:@"http://www.youtube.com/watch?v=lJs9tr75b70" frame:CGRectMake(151, 87, 156, 100)];
    
    
    [self embedYouTube:@"http://www.youtube.com/embed/lJs9tr75b70?rel=0" frame:self.videoWebView.frame];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Rapid Return Exercise", @"");
	[label sizeToFit];
	
	self.phaseView.backgroundColor = [UIColor colorWithRed:0.157 green:0.380 blue:0.631 alpha:1];
    [self.phaseView.layer setCornerRadius:5.0];
    
	videoView.layer.cornerRadius = 5.0;
	execeriseDetails.layer.cornerRadius = 5.0;
	settingsView.layer.cornerRadius = 5.0;
	
	
	self.tableView.backgroundColor = [UIColor clearColor];
	
	UIBarButtonItem *addbtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector (addNewExe:)];
	self.navigationItem.rightBarButtonItem = addbtn;
    
    exerciseArray = [[NSMutableArray alloc] init];
    
	
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    exerciseArray = [[delegate readRapidReturnExercisesFromDatabase] mutableCopy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // if([userDefaults objectForKey:])
    if([userDefaults objectForKey:KIsRapidReturnOn]){
        [mainSwitch setOn:[[userDefaults objectForKey:KIsRapidReturnOn] boolValue]];
    }
    
    NSLog(@"exercise array retain count %d",[exerciseArray retainCount]);
    [self.tableView reloadData];
}
- (void)scheduleNotificationForIndexOfExercise:(int)indexOfExercise{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
    NSMutableDictionary  *dict = [[array objectAtIndex:indexOfExercise] mutableCopy];

    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    
    NSDate *fireDate;
    NSCalendarUnit repeatInterval;
    notification.repeatInterval = NSMinuteCalendarUnit; 
    Exercise *exercise = [exerciseArray objectAtIndex:indexOfExercise];
    //
    notification.soundName = @"Alarm Chicken.wav";
    notification.timeZone = [NSTimeZone systemTimeZone];
    
    //notification.alertBody = [NSString stringWithFormat:@"Exercise"];
    NSString *direction = @"Right";
    if([dict objectForKey:KIsLeft]){
        direction = @"Left";
    }
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"Rapid Return" forKey:KAlertType];
    [userInfo setObject:exercise.name forKey:KAlertName];
    notification.userInfo = userInfo;
    
    [userInfo release];
    
    notification.alertAction = [NSString stringWithFormat:@"View"];
    notification.alertBody = [NSString stringWithFormat:@"Perform %@ (%@)",exercise.name,direction];
    notification.hasAction = YES;
    notification.repeatCalendar = [NSCalendar currentCalendar];
    
        NSArray *intervalArray = [AppManager sharedInstance].intervalsArray;
    NSString *frequencyString = [dict objectForKey:KFrequency];
    
    if([frequencyString isEqualToString:[intervalArray objectAtIndex:0]]){
        // 30 mins
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*30];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:1]]){
        // 1 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*1];
        //fireDate = [NSDate date];
        repeatInterval = NSHourCalendarUnit;
        
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:2]]){
        // 2 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:3]]){
        // 3 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*3];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:4]]){
        // 4 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*4];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:5]]){
        // 5 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*5];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:6]]){
        // 6 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*6];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:7]]){
        // 7 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*7];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:8]]){
        // 8 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*8];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:9]]){
        // 9 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*9];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:10]]){
        // 10 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*10];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:11]]){
        // 11 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*11];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:12]]){
        // 12 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*12];
        repeatInterval = NSHourCalendarUnit;
    }
    
    //fireDate = [NSDate dateWithTimeIntervalSinceNow:50];
    //repeatInterval = NSMinuteCalendarUnit;
    
    notification.fireDate = fireDate;
    notification.repeatInterval = repeatInterval;
    
    if([dict objectForKey:KLocalNotification]){
        UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[dict objectForKey:KLocalNotification]];
        [[UIApplication sharedApplication] cancelLocalNotification:prevNotification]; 
        [dict removeObjectForKey:KLocalNotification];
    }
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSData *notifData = [NSKeyedArchiver archivedDataWithRootObject:notification];
    [dict setObject:notifData forKey:KLocalNotification];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:KIsOn];
    
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:KIsRapidReturnOn];
    [array replaceObjectAtIndex:indexOfExercise withObject:dict];
    [userDefaults setObject:array forKey:KRapidReturnArray];
    [userDefaults synchronize];
    
}

-(IBAction)mainSwitchValueChanged:(id)sender{
    UISwitch *switchObj = (UISwitch *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (switchObj.isOn) {
        
        NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
        
        for (int i = 0; i < [array count]; i++) {
            [self scheduleNotificationForIndexOfExercise:i];
        }
        
    }
    else{
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsRapidReturnOn];
        NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
        
        for (int i = 0; i < [array count]; i++){
            NSMutableDictionary *dict = [[array objectAtIndex:i] mutableCopy];
            [dict setObject:[NSNumber numberWithBool:NO] forKey:KIsOn];
            if([dict objectForKey:KLocalNotification]){
                UILocalNotification *notif = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[dict objectForKey:KLocalNotification]];
                [[UIApplication sharedApplication] cancelLocalNotification:notif];
                [dict removeObjectForKey:KLocalNotification];
                
            }
            [array replaceObjectAtIndex:i withObject:dict];
        }
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsRapidReturnOn];
        [userDefaults setObject:array forKey:KRapidReturnArray];
        [userDefaults synchronize];
    }
    
    
}
-(void)addNewExe:(id)sender {
	
    // To add new Exercise
    
    NewActivityController *aController = [[NewActivityController alloc] initWithNibName:@"NewActivityController" bundle:nil];
    aController.isRapidReturn = YES;
    [self presentModalViewController:aController animated:YES];
    
	[aController release];
}


-(IBAction)showInstruction:(id)sender {
	
	[MTPopupWindow showWindowWithHTMLFile:@"RapidReturnExercises" insideView:self.view];
	
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	//NSString *embedHTML = @"<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"%@\" allowfullscreen frameborder=\"10\"></iframe>";
    NSString *embedHTML = @"<iframe width=\"%0.f\" height=\"%0.f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>";
	NSString *html = [NSString stringWithFormat:embedHTML,frame.size.width, frame.size.height,urlString];
//	UIWebView *videoView1 = [[UIWebView alloc] initWithFrame:frame];
//	[videoView1 loadHTMLString:html baseURL:nil];
//	[self.view addSubview:videoView1];
//	[videoView1 release];
    [self.videoWebView loadHTMLString:html baseURL:nil];
    [self.videoWebView.scrollView setScrollEnabled:NO];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [exerciseArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    self.tableView.backgroundColor = [UIColor clearColor];
	// Configure the cell.
	Exercise *exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
	
	cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1];
	cell.textLabel.text = exercise.name;
	cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:17];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,100)];
	backView.backgroundColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
	backView.layer.cornerRadius = 8.0;
	cell.selectedBackgroundView = backView;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row >= 3) {
		CustomExerciseController *customController = [[CustomExerciseController alloc] initWithNibName:@"CustomExerciseController" bundle:nil];
        customController.exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:customController animated:YES];
        
        
	}
    else {
		
        DefaultExerciseController *sController = [[[DefaultExerciseController alloc] initWithNibName:@"DefaultExerciseController" bundle:nil] autorelease];
        sController.index = indexPath.row;
        
        Exercise *exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
        sController.exercise = [exercise retain];
        
        [self.navigationController pushViewController:sController animated:YES];
        
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setVideoWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [exerciseArray release];
    [_videoWebView release];
    [super dealloc];
}


@end

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
- (void)scheduleNotificationForExercise:(Exercise *)exercise rightSide:(BOOL)rightSide
{
    
    NSString * dictionaryKey = [[NSString alloc] initWithFormat:@"Rapid %@ - %i",exercise.name,exercise.exerciseId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *settingDic = [[userDefaults objectForKey:dictionaryKey] mutableCopy];
    
    if (!settingDic) {
        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
        [components setHour: 10];
        [components setMinute: 0];
        [components setSecond: 0];
        
        NSDate *startDate = [gregorian dateFromComponents: components];
        [components setHour: 22];
        [components setMinute: 0];
        [components setSecond: 0];
        NSDate *endDate = [gregorian dateFromComponents: components];
        [gregorian release];
        settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3 Beeps",KLeftSound,@"3 Beeps",KRightSound,@"5",KLeftFrequency,@"5",KRightFrequency,startDate,KLeftStartDays,endDate,KLeftEndDays,startDate,KRightStartDays,endDate,KRightEndDays,[NSNumber numberWithBool:YES],KIsLeft, nil];
        [userDefaults setObject:settingDic forKey:dictionaryKey];
        [userDefaults synchronize];

    }
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    
    //NSLog(@"Notification will be shown on: %@",[notification.fireDate description]);
    NSDate *fireDate;
    NSCalendarUnit repeatInterval;
    
    
    //notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    notification.repeatInterval = NSMinuteCalendarUnit;
    //
    NSString *alarmString = [settingDic objectForKey:KLeftSound];
    if (rightSide) {
        alarmString = [settingDic objectForKey:KRightSound];
    }
    if (![alarmString isEqualToString:@"Vibrate"]) {
        notification.soundName = [NSString stringWithFormat:@"%@.wav",alarmString];
    }
    notification.timeZone = [NSTimeZone systemTimeZone];
    NSLog(@"Exercise: %@",exercise.name);
    
    //notification.alertBody = [NSString stringWithFormat:@"Exercise"];
    NSString *direction = @"Right";
    if(rightSide){
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
    //30 Minutes", @"1 Hour", @"2 Hours", @"3 Hours",
    //@"4 Hours", @"5 Hours", @"6 Hours", @"7 Hours", @"8 Hours", @"9 Hours", @"10 Hours",
    //@"11 Hours", @"12 Hours"
    NSArray *intervalArray = [[AppManager sharedInstance] intervalsArray];
    //NSArray *intervalsNumArray = [[AppManager sharedInstance] intervalsNumArray];
    NSString *frequencyString = [intervalArray objectAtIndex:[[settingDic objectForKey:KLeftFrequency] intValue]];
    if (rightSide) {
        frequencyString = [intervalArray objectAtIndex:[[settingDic objectForKey:KRightFrequency] intValue]];
    }
    NSLog(@"frequency String: %@",frequencyString);
    //NSLog(@"frequency String: %@",[intervalArray objectAtIndex:1]);
    
    if([frequencyString isEqualToString:[intervalArray objectAtIndex:0]]){
        // 30 mins
        return;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:1]]){
        // 30 mins
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*30];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:2]]){
        // 1 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*1];
        //fireDate = [NSDate date];
        repeatInterval = NSHourCalendarUnit;
        
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:3]]){
        // 2 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:4]]){
        // 3 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*3];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:5]]){
        // 4 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*4];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:6]]){
        // 5 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*5];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:7]]){
        // 6 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*6];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:8]]){
        // 7 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*7];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:9]]){
        // 8 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*8];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:10]]){
        // 9 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*9];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:11]]){
        // 10 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*10];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:12]]){
        // 11 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*11];
        repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:13]]){
        // 12 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*12];
        repeatInterval = NSHourCalendarUnit;
    }else if([frequencyString isEqualToString:[intervalArray objectAtIndex:14]]){
        // 12 hour
        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
        repeatInterval = NSHourCalendarUnit;
    }
    
    //fireDate = [NSDate dateWithTimeIntervalSinceNow:50];
    //repeatInterval = NSMinuteCalendarUnit;
    
    notification.fireDate = fireDate;
    notification.repeatInterval = repeatInterval;
    NSString *key = KLeftLocalNotification;
    if (rightSide) {
        key = KRightLocalNotification;
    }
    if([settingDic objectForKey:key]){
        UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[settingDic objectForKey:key]];
        [[UIApplication sharedApplication] cancelLocalNotification:prevNotification];
        [settingDic removeObjectForKey:key];
        if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSData *notifData = [NSKeyedArchiver archivedDataWithRootObject:notification];
    [settingDic setObject:notifData forKey:key];
    [userDefaults setObject:settingDic forKey:dictionaryKey];
    [userDefaults synchronize];
}

-(IBAction)mainSwitchValueChanged:(id)sender{
    UISwitch *switchObj = (UISwitch *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (switchObj.isOn) {
         for (Exercise *exercise in exerciseArray)
         {
             [self scheduleNotificationForExercise:exercise rightSide:NO];
             [self scheduleNotificationForExercise:exercise rightSide:YES];
         }
    }
    else{
        for (Exercise *exercise in exerciseArray) {
           NSString * dictionaryKey = [[NSString alloc] initWithFormat:@"Rapid %@ - %i",exercise.name,exercise.exerciseId];
            NSMutableDictionary *settingDic = [[userDefaults objectForKey:dictionaryKey] mutableCopy];
            if([settingDic objectForKey:KLeftLocalNotification]){
                UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[settingDic objectForKey:KLeftLocalNotification]];
                [[UIApplication sharedApplication] cancelLocalNotification:prevNotification];
                [settingDic removeObjectForKey:KLeftLocalNotification];
            }
            if([settingDic objectForKey:KRightLocalNotification]){
                if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
                    [UIApplication sharedApplication].applicationIconBadgeNumber --;
                }
                UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[settingDic objectForKey:KRightLocalNotification]];
                [[UIApplication sharedApplication] cancelLocalNotification:prevNotification];
                [settingDic removeObjectForKey:KRightLocalNotification];
            }
            [userDefaults setObject:settingDic forKey:dictionaryKey];
            [userDefaults synchronize];
        }
        
    }
    [userDefaults setBool:switchObj.isOn forKey:KIsRapidReturnOn];
    [userDefaults synchronize];
}
-(void)addNewExe:(id)sender {
	
    // To add new Exercise
    
    NewActivityController *aController = [[NewActivityController alloc] initWithNibName:@"NewActivityController" bundle:nil];
    aController.isRapidReturn = YES;
    [self presentModalViewController:aController animated:YES];
    
	[aController release];
}


-(IBAction)showInstruction:(id)sender {
	
	[MTPopupWindow showWindowWithHTMLFile:@"RapidReturnExercises" insideView:self.view viewController:self];
	
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

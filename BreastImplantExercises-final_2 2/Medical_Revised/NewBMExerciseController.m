//
//  ShoulderRollController.m
//  Medical
//
//  Created by Askone on 3/26/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "NewBMExerciseController.h"
#import "AlarmSoundViewController.h"
#import "AppManager.h"
#import "Constants.h"



@implementation NewBMExerciseController
@synthesize  settingsView;
@synthesize startBtn, endBtn, frequncyBtn, customView;
@synthesize mainSwitch;
@synthesize tableView = _tableView;
@synthesize textNavBar;
@synthesize intervalArray;
@synthesize textfield;
@synthesize exercise;
@synthesize btnSelectAlarm;
@synthesize index;
@synthesize doneButtonItem;
@synthesize alarmString;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
	self.settingsView.backgroundColor = [UIColor colorWithRed:0.157 green:0.380 blue:0.631 alpha:1];
    
    settingsView.layer.cornerRadius = 5.0;
	
    mainSwitch.transform = CGAffineTransformMakeScale(0.80, 0.80);
    
	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.showsVerticalScrollIndicator = NO;
	[self.settingsView addSubview:self.tableView];
	[self.tableView setHidden:YES];
	
	self.textNavBar.tintColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
    
    self.intervalArray = [[AppManager sharedInstance].intervalsArray mutableCopy];
    
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *cancelBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    UIBarButtonItem *doneBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
    self.doneButtonItem = doneBtn;
    //[doneButtonItem setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    alarmString = @"Alarm Chicken";
    [self.btnSelectAlarm setTitle:alarmString forState:UIControlStateNormal];
    
}

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    //if(mainSwitch.isOn){
        [self activateExercise];
        [self.navigationController popViewControllerAnimated:YES];
    //}
}
-(IBAction)mainSwitchValueChanged:(id)sender{
    /*if(mainSwitch.isOn){
        [self.doneButtonItem setEnabled:YES];
    }
    else{
        [self.doneButtonItem setEnabled:NO];
    }*/
       
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",self.exercise.name);
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
    
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = label;
	label.text = exercise.name;
	[label sizeToFit];
    
    [self loadSettings];
    
}

-(void)loadSettings{
    // to load settings for this specific exercise
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:KBreastMassageArray];
    NSDictionary *dict = [array objectAtIndex:index];
    //
    NSString *buttonTitle = [NSString stringWithFormat:@"%@", [dict objectForKey:KFrequency]];
	[frequncyBtn setTitle:buttonTitle forState:UIControlStateNormal];
    //
    
    NSString *daysString = [NSString stringWithFormat:@"%i",[[dict objectForKey:KDays] intValue]];
    [endBtn setTitle:daysString forState:UIControlStateNormal];
    
    NSString *startDaysString = [NSString stringWithFormat:@"%i",[[dict objectForKey:KStartDays] intValue]];
    [startBtn setTitle:startDaysString forState:UIControlStateNormal];
    
    [mainSwitch setOn:[[dict objectForKey:KIsOn]boolValue]];
    
    if([[dict objectForKey:KIsLeft] boolValue]){
        [segmentedControl setSelectedSegmentIndex:0];
    }
    else{
        [segmentedControl setSelectedSegmentIndex:1];
    }
    
    
}
-(void)activateExercise{
    UISwitch *switchObj = self.mainSwitch;
    if (switchObj.isOn) {
        
        [self scheduleAlarms];
    }    
    else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
        NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
        
        [dict setObject:[NSNumber numberWithBool:NO] forKey:KIsOn];
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsBreastMassageOn];
        // Checking for any notification and then cancelling it.
        
        if([dict objectForKey:KLocalNotification]){
            UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[dict objectForKey:KLocalNotification]];
            NSLog(@"firedate : %@",[prevNotification.fireDate description]);
            [[UIApplication sharedApplication] cancelLocalNotification:prevNotification]; 
            [dict removeObjectForKey:KLocalNotification];
        }
        
        if([segmentedControl selectedSegmentIndex] == 0){
            
            [dict setValue:[NSNumber numberWithBool:YES] forKey:KIsLeft];
        }
        else{
            [dict setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
        }
        [array replaceObjectAtIndex:index withObject:dict];
        [userDefaults setObject:array forKey:KBreastMassageArray];
        [userDefaults synchronize];
    }    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count %d",[intervalArray count]);
	return [self.intervalArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    self.tableView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1];
	cell.textLabel.text = [self.intervalArray objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:15];
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
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseOut forView:self.tableView cache:YES];
	[self.tableView setHidden:YES];
	[UIView commitAnimations];
	NSString *buttonTitle = [NSString stringWithFormat:@"%@", [self.intervalArray objectAtIndex:indexPath.row]];
	[frequncyBtn setTitle:buttonTitle forState:UIControlStateNormal];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // updating defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
    NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
    [dict setObject:[self.intervalArray objectAtIndex:indexPath.row ] forKey:KFrequency];
    [array replaceObjectAtIndex:index withObject:dict];
    [userDefaults setObject:array forKey:KBreastMassageArray];
    [userDefaults synchronize];
	
}
-(IBAction)buttonPressed:(id)sender{
    
	if ([sender isEqual:startBtn]) {
		
		buttonActive = 1;
		CGRect frame = self.textNavBar.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		frame.origin.y = 393;
		self.textNavBar.frame = frame;
		[UIView commitAnimations];
		
	}if ([sender isEqual:endBtn]) {
        
		buttonActive = 2;
		CGRect frame = self.textNavBar.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		frame.origin.y = 393;
		self.textNavBar.frame = frame;
		[UIView commitAnimations];
		
	}if ([sender isEqual:frequncyBtn]) {
		
		[self.tableView setFrame:CGRectMake(132, 30, 120, 160)];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseOut forView:self.tableView cache:YES];
		[self.tableView setHidden:NO];
		[UIView commitAnimations];
	}
	
}



-(IBAction)doneEditing:(id)sender{
	
	if([textfield isFirstResponder]){
        CGRect frame = self.textNavBar.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        frame.origin.y = 440;
        self.textNavBar.frame = frame;
        self.customView.frame = CGRectMake(self.customView.frame.origin.x, (self.customView.frame.origin.y + 195.0), self.customView.frame.size.width, self.customView.frame.size.height);
        [UIView commitAnimations];
        
        if (buttonActive == 1) {
            
            [startBtn setTitle:[textfield text] forState:UIControlStateNormal];
        }
        else if (buttonActive == 2) {
            // saving defaults 
            if([[textfield text] length]!=0){
                
                int days = [[textfield text] intValue];
                NSString *daysString = [NSString stringWithFormat:@"%i",days];
                [endBtn setTitle:daysString forState:UIControlStateNormal];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
                NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
                
                [dict setObject:[NSNumber numberWithInt:days] forKey:KDays];
                [array replaceObjectAtIndex:index withObject:dict];
                [userDefaults setObject:array forKey:KBreastMassageArray];
                [userDefaults synchronize];
            }
            
        }
        
        [textfield resignFirstResponder];
    }
    else{
        CGRect frame = self.textNavBar.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        frame.origin.y = 440;
        self.textNavBar.frame = frame;
        [UIView commitAnimations];
    }
    
    //[textfield setText:@""];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	CGRect frame = self.textNavBar.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	frame.origin.y = 375;
	self.textNavBar.frame = frame;
	self.customView.frame = CGRectMake(self.customView.frame.origin.x, (self.customView.frame.origin.y - 195.0), self.customView.frame.size.width, self.customView.frame.size.height);
	[UIView commitAnimations];
	return YES;
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.exercise = nil;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setBtnSelectAlarm:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [exercise release];
    [doneButtonItem release];
    [alarmString release];
    [btnSelectAlarm release];
    [super dealloc];
}

-(void)scheduleAlarms{
    
    // frequency 
    // Days
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
    NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    
    //NSLog(@"Notification will be shown on: %@",[notification.fireDate description]);
    NSDate *fireDate;
    NSCalendarUnit repeatInterval;
    
    
    //notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    notification.repeatInterval = NSMinuteCalendarUnit; 
    //
    notification.soundName = [NSString stringWithFormat:@"%@.wav",alarmString];
    notification.timeZone = [NSTimeZone systemTimeZone];
    NSLog(@"%@",self.exercise.name);
    
    //notification.alertBody = [NSString stringWithFormat:@"Exercise"];
    NSString *direction = @"Right";
    if([segmentedControl selectedSegmentIndex] == 0){
        direction = @"Left";
    }
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"Breast Massage" forKey:KAlertType];
    [userInfo setObject:exercise.name forKey:KAlertName];
    notification.userInfo = userInfo;
    
    [userInfo release];
    
    notification.alertAction = [NSString stringWithFormat:@"View"];
    
    notification.alertBody = [NSString stringWithFormat:@"Perform %@ (%@)",self.exercise.name,direction];
    notification.hasAction = YES;
    notification.repeatCalendar = [NSCalendar currentCalendar];
    //30 Minutes", @"1 Hour", @"2 Hours", @"3 Hours",
    //@"4 Hours", @"5 Hours", @"6 Hours", @"7 Hours", @"8 Hours", @"9 Hours", @"10 Hours",
    //@"11 Hours", @"12 Hours"
    
    
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
    
    if([segmentedControl selectedSegmentIndex] == 0){
        [dict setValue:[NSNumber numberWithBool:YES] forKey:KIsLeft];
    }
    else{
        [dict setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
    }
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:KIsBreastMassageOn];
    [array replaceObjectAtIndex:index withObject:dict];
    [userDefaults setObject:array forKey:KBreastMassageArray];
    [userDefaults synchronize];
    
    
    
}

- (IBAction)selectAlarmButtonPressed:(UIButton *)sender 
{
    AlarmSoundViewController *controller = [[[AlarmSoundViewController alloc] initWithNibName:@"AlarmSoundViewController" bundle:nil] autorelease];
    controller.selectedString = self.alarmString;
    controller.delegate = self;
    
    [self presentModalViewController:controller animated:YES];


}
#pragma mark - AlarmControllerDelegate
-(void)didCancelSelectingAlarm
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)didFinishSelectingAlarmWithSelectedAlarm:(NSString *)selectedAlarmString
{
    [self dismissModalViewControllerAnimated:YES];
    self.alarmString = selectedAlarmString;
    [self.btnSelectAlarm setTitle:alarmString forState:UIControlStateNormal];
}



@end




























//
//  DefaultExerciseController.m
//  Medical
//
//  Created by Askone on 3/26/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "DefaultExerciseController.h"
#import "AlarmSoundViewController.h"
#import "AppManager.h"
#import "Constants.h"


@implementation DefaultExerciseController
@synthesize segmentedControl;
@synthesize  settingsView;
@synthesize startBtn, endBtn, frequncyBtn, customView;
@synthesize mainSwitch;
@synthesize tableView = _tableView;
@synthesize btnSelectAlarm;
@synthesize textNavBar;
@synthesize intervalArray,intervalNumArray;
@synthesize textfield;
@synthesize exercise;
@synthesize index;
@synthesize doneButtonItem;

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
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	self.textNavBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
    
	//NSArray *myArray = [AppManager sharedInstance].intervalsArray;
    
	//self.intervalArray = [[NSMutableArray alloc] initWithArray:myArray];
    self.intervalArray = [[AppManager sharedInstance].intervalsArray mutableCopy];
    self.intervalNumArray = [[AppManager sharedInstance].intervalsNumArray mutableCopy];
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *cancelBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    UIBarButtonItem *doneBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
    self.doneButtonItem = doneBtn;
    //[self.doneButtonItem setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    userDefault = [NSUserDefaults standardUserDefaults];
    dictionaryKey = [[NSString alloc] initWithFormat:@"Rapid %@ - %i",exercise.name,exercise.exerciseId];
    
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
    //NSLog(@"name: %@ , desc: %@ , url: %@",exercise.name,exercise.description,exercise.tubeURL);

    //alarmString = self.exercise.leftSound;

    //[btnSelectAlarm setTitle:alarmString forState:UIControlStateNormal];
}

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    //if(mainSwitch.isOn){
    [self saveSettings];
    if (mainSwitch.isOn) {
        [self scheduleAlarms:NO];
        [self scheduleAlarms:YES];
    }
    //[self activateExercise];
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

- (void)saveSettings
{
    NSMutableDictionary *oldSetting = [userDefault objectForKey:dictionaryKey];
    
    NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:leftSound,KLeftSound,rightSound,KRightSound,leftFreq,KLeftFrequency,rightFreq,KRightFrequency,leftStartDay,KLeftStartDays,leftEndDay,KLeftEndDays,rightStartDay,KRightStartDays,rightEndDay,KRightEndDays,[NSNumber numberWithBool:isLeft],KIsLeft, nil];
    if ([oldSetting objectForKey:KLeftLocalNotification]) {
        [settingDic setObject:[oldSetting objectForKey:KLeftLocalNotification] forKey:KLeftLocalNotification];
    }
    if ([oldSetting objectForKey:KRightLocalNotification]) {
        [settingDic setObject:[oldSetting objectForKey:KRightLocalNotification] forKey:KRightLocalNotification];
    }
    [userDefault setObject:settingDic forKey:dictionaryKey];
    [userDefault synchronize];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
    
    
	
    
}

-(void)loadSettings{
    // to load settings for this specific exercise
    
//    NSArray *array = [defaults objectForKey:KRapidReturnArray];
//    NSDictionary *dict = [array objectAtIndex:index];
//    //
//    NSString *buttonTitle = [NSString stringWithFormat:@"%@", [dict objectForKey:KFrequency]];
//	[frequncyBtn setTitle:buttonTitle forState:UIControlStateNormal];
//    //
//    NSString *daysString = [NSString stringWithFormat:@"%i",[[dict objectForKey:KDays] intValue]];
//    [endBtn setTitle:daysString forState:UIControlStateNormal];
//    
//    [mainSwitch setOn:[[dict objectForKey:KIsOn]boolValue]];
//    if(mainSwitch.isOn){
//        [self.doneButtonItem setEnabled:YES];
//    }
//    
//    if([[dict objectForKey:KIsLeft] boolValue]){
//        [segmentedControl setSelectedSegmentIndex:0];
//    }
//    else{
//        [segmentedControl setSelectedSegmentIndex:1];
//    }
    NSMutableDictionary *settingDic = [userDefault objectForKey:dictionaryKey];
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
        [userDefault setObject:settingDic forKey:dictionaryKey];
        [userDefault synchronize];
    }
    isLeft = [[settingDic objectForKey:KIsLeft] boolValue];
    leftSound = [settingDic objectForKey:KLeftSound];
    rightSound = [settingDic objectForKey:KRightSound];
    leftFreq = [settingDic objectForKey:KLeftFrequency];
    rightFreq = [settingDic objectForKey:KRightFrequency];
    leftStartDay = [settingDic objectForKey:KLeftStartDays];
    leftEndDay = [settingDic objectForKey:KLeftEndDays];
    rightStartDay = [settingDic objectForKey:KRightStartDays];
    rightEndDay = [settingDic objectForKey:KRightEndDays];
    [self reloadSettings];
}

- (void)reloadSettings
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd HH:mm"];
    if (isLeft) {
        [segmentedControl setSelectedSegmentIndex:0];
        [btnSelectAlarm setTitle:leftSound forState:UIControlStateNormal];
        
        [frequncyBtn setTitle:[self.intervalArray objectAtIndex:[leftFreq intValue]] forState:UIControlStateNormal];
        NSString *startDay = [formatter stringFromDate:leftStartDay];
        [startBtn setTitle:startDay forState:UIControlStateNormal];
        NSString *endDay = [formatter stringFromDate:leftEndDay];
        [endBtn setTitle:endDay forState:UIControlStateNormal];
    }
    else
    {
        [segmentedControl setSelectedSegmentIndex:1];
        [btnSelectAlarm setTitle:rightSound forState:UIControlStateNormal];
        [frequncyBtn setTitle:[self.intervalArray objectAtIndex:[rightFreq intValue]] forState:UIControlStateNormal];
        NSString *startDay = [formatter stringFromDate:rightStartDay];
        [startBtn setTitle:startDay forState:UIControlStateNormal];
        NSString *endDay = [formatter stringFromDate:rightEndDay];
        [endBtn setTitle:endDay forState:UIControlStateNormal];
    }
}

- (void)showPickerView
{
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [picker setMinimumDate:[NSDate date]];
    [picker setDate:[NSDate date]];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDoneClick)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    actionsheet = [[UIActionSheet alloc] init];
    [actionsheet addSubview:pickerDateToolbar];
    [actionsheet addSubview:picker];
    [actionsheet showInView:self.view];
    [actionsheet setBounds:CGRectMake(0,0,320, 464)];
}

- (void)buttonDoneClick
{
    if (isLeft)
    {
        if (isEndDay) {
            leftEndDay = [picker.date copy];
        }
        else
        {
            leftStartDay = [picker.date copy];
        }
    }
    else
    {
        if (isEndDay) {
            rightEndDay = [picker.date copy];
        }
        else
        {
            rightStartDay = [picker.date copy];
        }
    }
    [actionsheet dismissWithClickedButtonIndex:100 animated:YES];
    [self reloadSettings];
}

//-(void)activateExercise{
//    
//    
//    UISwitch *switchObj = self.mainSwitch;
//    if (switchObj.isOn) {
//        
//        [self scheduleAlarms];
//    }    
//    else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
//        NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
//        
//        [dict setObject:[NSNumber numberWithBool:NO] forKey:KIsOn];
//        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsRapidReturnOn];
//        // Checking for any notification and then cancelling it.
//        
//        if([dict objectForKey:KLocalNotification]){
//            UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[dict objectForKey:KLocalNotification]];
//            NSLog(@"firedate : %@",[prevNotification.fireDate description]);
//            [[UIApplication sharedApplication] cancelLocalNotification:prevNotification]; 
//            [dict removeObjectForKey:KLocalNotification];
//        }
//        
//        if([segmentedControl selectedSegmentIndex] == 0){
//            
//            [dict setValue:[NSNumber numberWithBool:YES] forKey:KIsLeft];
//        }
//        else{
//            [dict setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
//        }
//        [array replaceObjectAtIndex:index withObject:dict];
//        [userDefaults setObject:array forKey:KRapidReturnArray];
//        [userDefaults synchronize];
//    }
//    
//}
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
    if (isLeft) {
        leftFreq = [[NSString alloc] initWithFormat:@"%i", indexPath.row];
    }
    else
    {
        rightFreq = [[NSString alloc] initWithFormat:@"%i", indexPath.row];
    }
//    // updating defaults
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
//    NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
//    [dict setObject:[self.intervalArray objectAtIndex:indexPath.row ] forKey:KFrequency];
//    [array replaceObjectAtIndex:index withObject:dict];
//    [userDefaults setObject:array forKey:KRapidReturnArray];
//    [userDefaults synchronize];
	
}

-(IBAction)buttonPressed:(id)sender{
    
	if ([sender isEqual:startBtn]) {
		isEndDay = NO;
		buttonActive = 1;
        [self showPickerView];
		
	}if ([sender isEqual:endBtn]) {
        isEndDay = YES;
		buttonActive = 2;
        [self showPickerView];
		
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
                NSMutableArray *array = [[userDefaults objectForKey:KRapidReturnArray] mutableCopy];
                NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
                
                [dict setObject:[NSNumber numberWithInt:days] forKey:KDays];
                [array replaceObjectAtIndex:index withObject:dict];
                [userDefaults setObject:array forKey:KRapidReturnArray];
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
    [self setSegmentedControl:nil];
    [self setBtnSelectAlarm:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [exercise release];
    [doneButtonItem release];
    [segmentedControl release];
    [btnSelectAlarm release];
    [super dealloc];
}

-(void)scheduleAlarms:(BOOL)rightSide
{
    
    // frequency 
    // Days
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *settingDic = [[userDefault objectForKey:dictionaryKey] mutableCopy];

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
    NSLog(@"Exercise: %@",self.exercise.name);
    
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
    notification.alertBody = [NSString stringWithFormat:@"Perform %@ (%@)",self.exercise.name,direction];
    notification.hasAction = YES;
    notification.repeatCalendar = [NSCalendar currentCalendar];
    //30 Minutes", @"1 Hour", @"2 Hours", @"3 Hours",
    //@"4 Hours", @"5 Hours", @"6 Hours", @"7 Hours", @"8 Hours", @"9 Hours", @"10 Hours",
    //@"11 Hours", @"12 Hours"
        
    NSString *frequencyString = [self.intervalArray objectAtIndex:[[settingDic objectForKey:KLeftFrequency] intValue]];
    if (rightSide) {
        frequencyString = [self.intervalArray objectAtIndex:[[settingDic objectForKey:KRightFrequency] intValue]];
    }
    NSLog(@"frequency String: %@",frequencyString);
    //NSLog(@"frequency String: %@",[intervalArray objectAtIndex:1]);
    
    if([frequencyString isEqualToString:[intervalArray objectAtIndex:0]]){
        // 30 mins
        fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
        repeatInterval = NSHourCalendarUnit;;
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
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:14]]){
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

- (IBAction)selectAlarmButtonPressed:(UIButton *)sender {
    AlarmSoundViewController *controller = [[[AlarmSoundViewController alloc] initWithNibName:@"AlarmSoundViewController" bundle:nil] autorelease];
    controller.selectedString = self.btnSelectAlarm.titleLabel.text;
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
    //self.alarmString = selectedAlarmString;
    if (isLeft) {
        leftSound = selectedAlarmString;
        [self.btnSelectAlarm setTitle:leftSound forState:UIControlStateNormal];
    }
    else
    {
        rightSound = selectedAlarmString;
        [self.btnSelectAlarm setTitle:rightSound forState:UIControlStateNormal];
    }
    
}

- (IBAction)switchValueChanged:(id)sender
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        isLeft = YES;
    }
    else{
        isLeft = NO;
    }
    
    [self reloadSettings];
}
@end






























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
#import "ExerciseHelpViewController.h"


@implementation NewBMExerciseController
@synthesize  settingsView;
@synthesize startBtn, endBtn, frequncyBtn, customView,startTimeButton,endTimeButton;
@synthesize mainSwitch;
@synthesize tableView = _tableView;
@synthesize textNavBar;
@synthesize intervalArray;
@synthesize textfield;
@synthesize exercise;
@synthesize btnSelectAlarm;
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
	
	self.textNavBar.tintColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
    
    self.intervalArray = [[AppManager sharedInstance].intervalsArray mutableCopy];
    
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *cancelBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    UIBarButtonItem *doneBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
    self.doneButtonItem = doneBtn;
    //[doneButtonItem setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
//    alarmString = @"Alarm Chicken";
//    [self.btnSelectAlarm setTitle:alarmString forState:UIControlStateNormal];
    userDefault = [NSUserDefaults standardUserDefaults];
    dictionaryKey = [[NSString alloc] initWithFormat:@"BMExercise %@ - %i",exercise.name,exercise.exerciseId];
    
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

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    //if(mainSwitch.isOn){
        //[self activateExercise];
    [self saveSettings];
    if (mainSwitch.isOn) {
        [self scheduleAlarms:NO];
        [self scheduleAlarms:YES];
    }
        [self.navigationController popViewControllerAnimated:YES];
    //}
}

- (void)saveSettings
{
    NSMutableDictionary *oldSetting = [userDefault objectForKey:dictionaryKey];
    
    NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:leftSound,KLeftSound,rightSound,KRightSound,leftFreq,KLeftFrequency,rightFreq,KRightFrequency,leftStartDay,KLeftStartDays,leftEndDay,KLeftEndDays,rightStartDay,KRightStartDays,rightEndDay,KRightEndDays,leftStartTime,KLeftStartTime,leftEndTime,KLeftEndTime,rightStartTime,KRightStartTime,rightEndTime,KRightEndTime,[NSNumber numberWithBool:isLeft],KIsLeft, nil];
    if ([oldSetting objectForKey:KLeftLocalNotification]) {
        [settingDic setObject:[oldSetting objectForKey:KLeftLocalNotification] forKey:KLeftLocalNotification];
    }
    if ([oldSetting objectForKey:KRightLocalNotification]) {
        [settingDic setObject:[oldSetting objectForKey:KRightLocalNotification] forKey:KRightLocalNotification];
    }
    [userDefault setObject:settingDic forKey:dictionaryKey];
    [userDefault synchronize];
    
}

-(IBAction)mainSwitchValueChanged:(id)sender
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        isLeft = YES;
    }
    else{
        isLeft = NO;
    }
    
    [self reloadSettings];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![userDefault boolForKey:KExerciseHelp]) {
        NSString *nibName = @"ExerciseHelpViewController";
        if (IS_IPAD()) {
            nibName = @"ExerciseHelpViewController-ipad";
        }
        ExerciseHelpViewController *exerciseHelpViewController = [[ExerciseHelpViewController alloc] initWithNibName:nibName bundle:nil];
        
        [self presentViewController:exerciseHelpViewController animated:NO completion:nil];
    }
}

-(void)loadSettings{
    
    NSMutableDictionary *settingDic = [userDefault objectForKey:dictionaryKey];
    if (!settingDic) {
        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
        [components setHour: 0];
        [components setMinute: 0];
        [components setSecond: 0];
        
        NSDate *startDate = [gregorian dateFromComponents: components];
        [components setHour: 23];
        [components setMinute: 59];
        [components setSecond: 59];
        NSDate *endDate = [gregorian dateFromComponents: components];
        
        [components setHour: 10];
        [components setMinute: 0];
        [components setSecond: 0];
        NSDate *startTime = [gregorian dateFromComponents: components];
        [components setHour: 22];
        [components setMinute: 0];
        [components setSecond: 0];
        NSDate *endTime = [gregorian dateFromComponents: components];
        [gregorian release];
        settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3 Beeps",KLeftSound,@"3 Beeps",KRightSound,@"5",KLeftFrequency,@"5",KRightFrequency,startDate,KLeftStartDays,endDate,KLeftEndDays,startDate,KRightStartDays,endDate,KRightEndDays,startTime,KLeftStartTime,endTime,KLeftEndTime,startTime,KRightStartTime,endTime,KRightEndTime,[NSNumber numberWithBool:YES],KIsLeft, nil];
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
    leftStartTime = [settingDic objectForKey:KLeftStartTime];
    leftEndTime = [settingDic objectForKey:KLeftEndTime];
    rightStartTime = [settingDic objectForKey:KRightStartTime];
    rightEndTime = [settingDic objectForKey:KRightEndTime];
    [self reloadSettings];
}

- (void)reloadSettings
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd"];
    if (isLeft) {
        [segmentedControl setSelectedSegmentIndex:0];
        [btnSelectAlarm setTitle:leftSound forState:UIControlStateNormal];
        
        [frequncyBtn setTitle:[self.intervalArray objectAtIndex:[leftFreq intValue]] forState:UIControlStateNormal];
        NSString *startDay = [formatter stringFromDate:leftStartDay];
        [startBtn setTitle:startDay forState:UIControlStateNormal];
        NSString *endDay = [formatter stringFromDate:leftEndDay];
        [endBtn setTitle:endDay forState:UIControlStateNormal];
        [formatter setDateFormat:@"h:mm a"];
        NSString *startTime = [formatter stringFromDate:leftStartTime];
        [startTimeButton setTitle:startTime forState:UIControlStateNormal];
        NSString *endTime = [formatter stringFromDate:leftEndTime];
        [endTimeButton setTitle:endTime forState:UIControlStateNormal];
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
        [formatter setDateFormat:@"h:mm a"];
        NSString *startTime = [formatter stringFromDate:rightStartTime];
        [startTimeButton setTitle:startTime forState:UIControlStateNormal];
        NSString *endTime = [formatter stringFromDate:rightEndTime];
        [endTimeButton setTitle:endTime forState:UIControlStateNormal];
    }
}

//-(void)activateExercise{
//    UISwitch *switchObj = self.mainSwitch;
//    if (switchObj.isOn) {
//        
//        [self scheduleAlarms];
//    }    
//    else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
//        NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
//        
//        [dict setObject:[NSNumber numberWithBool:NO] forKey:KIsOn];
//        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsBreastMassageOn];
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
//        [userDefaults setObject:array forKey:KBreastMassageArray];
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
//    NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
//    NSMutableDictionary  *dict = [[array objectAtIndex:self.index] mutableCopy];
//    [dict setObject:[self.intervalArray objectAtIndex:indexPath.row ] forKey:KFrequency];
//    [array replaceObjectAtIndex:index withObject:dict];
//    [userDefaults setObject:array forKey:KBreastMassageArray];
//    [userDefaults synchronize];
	
}
-(IBAction)buttonPressed:(id)sender{
    
    if ([sender isEqual:startBtn]) {
		isEndDay = NO;
		buttonActive = 0;
        if (IS_IPAD()) {
            [self showPickerView3];
        }
        else
        {
            [self showPickerView];
        }
        
		
	}if ([sender isEqual:endBtn]) {
        isEndDay = YES;
		buttonActive = 0;
        if (IS_IPAD()) {
            [self showPickerView3];
        }
        else
        {
            [self showPickerView];
        }
		
	}
    
    if ([sender isEqual:startTimeButton]) {
		isEndDay = NO;
		buttonActive = 1;
        if (IS_IPAD()) {
            [self showPickerView4];
        }
        else
        {
            [self showPickerView2];
        }
		
	}if ([sender isEqual:endTimeButton]) {
        isEndDay = YES;
		buttonActive = 1;
        if (IS_IPAD()) {
            [self showPickerView4];
        }
        else
        {
            [self showPickerView2];
        }
		
	}

    if ([sender isEqual:frequncyBtn]) {
		
		[self.tableView setFrame:CGRectMake(132, 30, 120, 160)];
        if (IS_IPAD()) {
            
            [self.tableView setFrame:CGRectMake(frequncyBtn.frame.origin.x, frequncyBtn.frame.origin.y+frequncyBtn.frame.size.height, frequncyBtn.frame.size.width, 300)];
        }
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseOut forView:self.tableView cache:YES];
		[self.tableView setHidden:NO];
		[UIView commitAnimations];
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

- (void)showPickerView2
{
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.datePickerMode = UIDatePickerModeTime;
    
    NSDate *currentDate = [NSDate date];
    if (isLeft) {
        if (isEndDay) {
            currentDate = leftEndTime;
        }
        else
        {
            currentDate = leftStartTime;
        }
    }
    else
    {
        if (isEndDay) {
            currentDate = rightEndTime;
        }
        else
        {
            currentDate = rightStartTime;
        }
    }
    [picker setDate:currentDate];
    
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

- (void)showPickerView3
{
    UIViewController *controller = [[UIViewController alloc] init];
    [controller setContentSizeForViewInPopover:CGSizeMake(320, 300)];
    
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.datePickerMode = UIDatePickerModeDate;
    NSDate *currentDate = [NSDate date];
    if (isLeft) {
        if (isEndDay) {
            currentDate = leftEndDay;
        }
        else
        {
            currentDate = leftStartDay;
        }
    }
    else
    {
        if (isEndDay) {
            currentDate = rightEndDay;
        }
        else
        {
            currentDate = rightStartDay;
        }
    }
    [picker setDate:currentDate];
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDoneClick)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    [controller.view addSubview:pickerDateToolbar];
    [controller.view addSubview:picker];
    popoverController3 = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popoverController3 setDelegate:self];
    [popoverController3 presentPopoverFromRect:CGRectMake(self.view.center.x, self.view.center.y, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showPickerView4
{
    UIViewController *controller = [[UIViewController alloc] init];
    [controller setContentSizeForViewInPopover:CGSizeMake(320, 300)];
    
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.datePickerMode = UIDatePickerModeTime;
    
    NSDate *currentDate = [NSDate date];
    if (isLeft) {
        if (isEndDay) {
            currentDate = leftEndTime;
        }
        else
        {
            currentDate = leftStartTime;
        }
    }
    else
    {
        if (isEndDay) {
            currentDate = rightEndTime;
        }
        else
        {
            currentDate = rightStartTime;
        }
    }
    [picker setDate:currentDate];
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDoneClick)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    [controller.view addSubview:pickerDateToolbar];
    [controller.view addSubview:picker];
    popoverController3 = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popoverController3 setDelegate:self];
    [popoverController3 presentPopoverFromRect:CGRectMake(self.view.center.x, self.view.center.y, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)buttonDoneClick
{
    if (isLeft)
    {
        if (buttonActive == 0) {
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
                leftEndTime = [picker.date copy];
            }
            else
            {
                leftStartTime = [picker.date copy];
            }
        }
        
    }
    else
    {
        if (buttonActive == 0)
        {
            if (isEndDay) {
                rightEndDay = [picker.date copy];
            }
            else
            {
                rightStartDay = [picker.date copy];
            }
        }
        else
        {
            if (isEndDay) {
                rightEndTime = [picker.date copy];
            }
            else
            {
                rightStartTime = [picker.date copy];
            }
        }
    }
    [actionsheet dismissWithClickedButtonIndex:100 animated:YES];
    [self reloadSettings];
    if (popoverController3) {
        [popoverController3 dismissPopoverAnimated:YES];
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
    [btnSelectAlarm release];
    [super dealloc];
}

-(void)scheduleAlarms:(BOOL)rightSide
{
    // frequency
    // Days
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *settingDic = [[userDefault objectForKey:dictionaryKey] mutableCopy];
    
    //
    NSString *alarmString = [settingDic objectForKey:KLeftSound];
    NSDate *startDay = leftStartDay;
    NSDate *startTime = leftStartTime;
    NSDate *endDay = leftEndDay;
    NSDate *endTime = leftEndTime;
    if (rightSide) {
        alarmString = [settingDic objectForKey:KRightSound];
        startDay = rightStartDay;
        startTime = rightStartTime;
        endDay = rightEndDay;
        endTime = rightEndTime;
    }
    NSString *key = KLeftLocalNotification;
    if (rightSide) {
        key = KRightLocalNotification;
    }
    if([settingDic objectForKey:key])
    {
        NSArray *array = [settingDic objectForKey:key];
        for (NSData *data in array) {
            UILocalNotification *prevNotification = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [[UIApplication sharedApplication] cancelLocalNotification:prevNotification];
        }
        [settingDic removeObjectForKey:key];
        if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
        }
    }
    
    
    NSLog(@"Exercise: %@",self.exercise.name);
    
    //notification.alertBody = [NSString stringWithFormat:@"Exercise"];
    NSString *direction = @"Right";
    if(rightSide){
        direction = @"Left";
    }
    
    //30 Minutes", @"1 Hour", @"2 Hours", @"3 Hours",
    //@"4 Hours", @"5 Hours", @"6 Hours", @"7 Hours", @"8 Hours", @"9 Hours", @"10 Hours",
    //@"11 Hours", @"12 Hours"
    
    NSString *frequencyString = [self.intervalArray objectAtIndex:[[settingDic objectForKey:KLeftFrequency] intValue]];
    if (rightSide) {
        frequencyString = [self.intervalArray objectAtIndex:[[settingDic objectForKey:KRightFrequency] intValue]];
    }
    NSLog(@"frequency String: %@",frequencyString);
    //NSLog(@"frequency String: %@",[intervalArray objectAtIndex:1]);
    NSTimeInterval timeInterval = 0;
    if([frequencyString isEqualToString:[intervalArray objectAtIndex:0]]){
        [userDefaults setObject:settingDic forKey:dictionaryKey];
        [userDefaults synchronize];
        return;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:1]]){
        // 30 mins
        timeInterval = 60*30;
        //fireDate = [NSDate dateWithTimeIntervalSinceNow:60*30];
        //repeatInterval = NSHourCalendarUnit;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:2]]){
        // 1 hour
        //fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*1];
        //fireDate = [NSDate date];
        //repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*1;
        
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:3]]){
        // 2 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*2;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:4]]){
        // 3 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*3];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*3;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:5]]){
        // 4 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*4];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*4;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:6]]){
        // 5 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*5];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*5;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:7]]){
        // 6 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*6];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*6;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:8]]){
        // 7 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*7];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*7;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:9]]){
        // 8 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*8];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*8;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:10]]){
        // 9 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*9];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*9;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:11]]){
        // 10 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*10];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*10;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:12]]){
        // 11 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*11];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*1;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:13]]){
        // 12 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*12];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*12;
    }
    else if([frequencyString isEqualToString:[intervalArray objectAtIndex:14]]){
        // 12 hour
        //        fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
        //        repeatInterval = NSHourCalendarUnit;
        timeInterval = 60*60*24;
    }
    
    
    
    //fireDate = [NSDate dateWithTimeIntervalSinceNow:50];
    //repeatInterval = NSMinuteCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: startDay];
    NSDateComponents *components2 = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startTime];
    NSInteger hour = [components2 hour];
    NSInteger minute = [components2 minute];
    [components setHour: hour ];
    [components setMinute: minute];
    [components setSecond: 0];
    NSDate *tempStartDate = [gregorian dateFromComponents: components];
    
    components = [gregorian components: NSUIntegerMax fromDate: endDay];
    components2 = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:endTime];
    hour = [components2 hour];
    minute = [components2 minute];
    [components setHour: hour ];
    [components setMinute: minute];
    [components setSecond: 0];
    NSDate *tempEndDate = [gregorian dateFromComponents: components];
    NSDate *tempCurrentDate = [NSDate date];
    BOOL isBreak = NO;
    NSMutableArray *notifyList = [[NSMutableArray alloc] initWithCapacity:0];
    
    while (!isBreak) {
        if (([tempStartDate compare:tempEndDate] ==  NSOrderedAscending || [tempStartDate compare:tempEndDate] ==  NSOrderedSame) && ([tempStartDate compare:tempCurrentDate] ==  NSOrderedDescending || [tempStartDate compare:tempCurrentDate] ==  NSOrderedSame))
        {
            
            UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
            
            //NSLog(@"Notification will be shown on: %@",[notification.fireDate description]);
            notification.timeZone = [NSTimeZone systemTimeZone];
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:@"Breast Massage" forKey:KAlertType];
            [userInfo setObject:exercise.name forKey:KAlertName];
            notification.userInfo = userInfo;
            
            [userInfo release];
            
            
            notification.alertAction = [NSString stringWithFormat:@"View"];
            notification.alertBody = [NSString stringWithFormat:@"Perform %@ (%@)",self.exercise.name,direction];
            notification.hasAction = YES;
            notification.fireDate = tempStartDate;
            
            if (![alarmString isEqualToString:@"Vibrate"]) {
                notification.soundName = [NSString stringWithFormat:@"%@.wav",alarmString];
            }
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            NSData *notifData = [NSKeyedArchiver archivedDataWithRootObject:notification];
            [notifyList addObject:notifData];
        }
        tempStartDate = [tempStartDate dateByAddingTimeInterval:timeInterval];
        if ([tempStartDate compare:tempEndDate] == NSOrderedDescending || [tempEndDate compare:tempCurrentDate] == NSOrderedAscending) {
            isBreak = YES;
        }
    }
    
    if ([notifyList count] > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber++;
        [settingDic setObject:notifyList forKey:key];
        [userDefaults setObject:settingDic forKey:dictionaryKey];
        [userDefaults synchronize];
    }
    
}

- (IBAction)selectAlarmButtonPressed:(UIButton *)sender 
{
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




























//
//  BreastMassageController.m
//  Medical
//
//  Created by Mac Mni on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreastMassageController.h"
#import "AppDelegate.h"
#import "NewBMExercise.h"
#import "CustomExerciseController.h"
#import "NewActivityController.h"
#import "NewBMExerciseController.h"
#import "MTPopupWindow.h"
#import "AppManager.h"
@implementation BreastMassageController

@synthesize phaseView;
@synthesize videoView;
@synthesize instructionView;
@synthesize tableView= _tableView;
@synthesize exerciseArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)dealloc{
    
    [phaseView release];
    [videoView release];
    [instructionView release];
    [self.tableView release];
    [exerciseArray release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    exerciseArray = [[NSMutableArray alloc] init];
    CGRect frame = videoView.frame;
    frame.origin.y = frame.origin.y + 21;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self embedYouTube:@"http://youtube.com/watch?v=GwNdV66ZGxY" frame:frame];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
    
    
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Breast Massage", @"");
	[label sizeToFit];
    
    self.phaseView.backgroundColor = [UIColor colorWithRed:0.157 green:0.380 blue:0.631 alpha:1];
    [self.phaseView.layer setCornerRadius:5.0];
	videoView.layer.cornerRadius = 5.0;
	instructionView.layer.cornerRadius = 5.0;
    
    UIBarButtonItem *addbtn = [[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector (addNewExe:)] autorelease];
	self.navigationItem.rightBarButtonItem = addbtn;
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    exerciseArray = [[delegate readBreastMassageExercisesFromDatabase] mutableCopy];
    
    NSLog(@"count: %d",[exerciseArray count]);
    [self.tableView reloadData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // if([userDefaults objectForKey:])
    if([userDefaults objectForKey:KIsBreastMassageOn]){
        [mainSwitch setOn:[[userDefaults objectForKey:KIsBreastMassageOn] boolValue]];
    }
    
    
}
-(void)addNewExe:(id)sender{
    
    NewActivityController *aController = [[NewActivityController alloc] initWithNibName:@"NewActivityController" bundle:nil];
    aController.isRapidReturn = NO;
    [self presentModalViewController:aController animated:YES];
    
	[aController release];
    
}

-(IBAction)showInstruction:(id)sender {
	
	[MTPopupWindow showWindowWithHTMLFile:@"BreastMassageInstructions" insideView:self.view];
	
}
-(IBAction)mainSwitchValueChanged:(id)sender{
    UISwitch *switchObj = (UISwitch *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (switchObj.isOn) {
        
        NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
        
        for (int i = 0; i < [array count]; i++) {
            [self scheduleNotificationForIndexOfExercise:i];
        }
        
    }
    else{
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsBreastMassageOn];
        NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
        
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
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:KIsBreastMassageOn];
        [userDefaults setObject:array forKey:KBreastMassageArray];
        [userDefaults synchronize];
    }
    
}

- (void)scheduleNotificationForIndexOfExercise:(int)indexOfExercise{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[userDefaults objectForKey:KBreastMassageArray] mutableCopy];
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
    [userInfo setObject:@"Breast Massage" forKey:KAlertType];
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
    
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:KIsBreastMassageOn];
    [array replaceObjectAtIndex:indexOfExercise withObject:dict];
    [userDefaults setObject:array forKey:KBreastMassageArray];
    [userDefaults synchronize];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.phaseView = nil;
    self.videoView = nil;
    self.instructionView = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	align: center;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
	UIWebView *videoView1 = [[UIWebView alloc] initWithFrame:frame];
	[videoView1 loadHTMLString:html baseURL:nil];
	[self.view addSubview:videoView1];
	[videoView1 release];
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
    NSLog(@"array count %d",[exerciseArray count]);
	return [exerciseArray count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
    if(indexPath.row < [exerciseArray count]){
        static NSString *cellIdentifier = @"Cell1"; 
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1];
            
            cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:17];
            cell.textLabel.textColor = [UIColor whiteColor];
            
            UIView * backView = [[[UIView alloc]initWithFrame:CGRectMake(0,0, 320,100)] autorelease];
            backView.backgroundColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
            backView.layer.cornerRadius = 8.0;
            cell.selectedBackgroundView = backView;
        }
        Exercise *exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
        cell.textLabel.text = exercise.name;
    }
    
    else{
        static NSString* cellIdentifier = @"Cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,100)];
        backView.backgroundColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
        backView.layer.cornerRadius = 8.0;
        cell.selectedBackgroundView = backView;
        //cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setText:@"Add New Exercise"];
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // NewBMExercise *newController = [[[NewBMExercise alloc] initWithNibName:@"NewBMExercise" bundle:nil] autorelease];
    NewBMExerciseController *newController = [[[NewBMExerciseController alloc] initWithNibName:@"NewBMExerciseController" bundle:nil] autorelease];
    
    if(indexPath.row < 6){
        // Set Edit Mode
        //[newController setIsEditMode:YES];
        Exercise *exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
        newController.exercise = [exercise retain];
        newController.index = indexPath.row;
        //UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:newController] autorelease];
        //[self presentModalViewController:navController animated:YES];    
        [self.navigationController pushViewController:newController animated:YES];
    }
    else if(indexPath.row == [exerciseArray count]){
        // Add New
        [self addNewExe:self];
    }
    else{
        CustomExerciseController *customController = [[CustomExerciseController alloc] initWithNibName:@"CustomExerciseController" bundle:nil];
        customController.exercise = (Exercise *)[exerciseArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:customController animated:YES];
    }
}





@end

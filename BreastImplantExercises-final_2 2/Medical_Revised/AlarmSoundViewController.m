//
//  AlarmSoundViewController.m
//  Medical_Revised
//
//  Created by Mac Mni on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmSoundViewController.h"

@implementation AlarmSoundViewController
@synthesize soundsArray;
@synthesize selectedString;
@synthesize player;
@synthesize tableView;
@synthesize delegate;

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
    AudioServicesDisposeSystemSoundID(_alarmSoundId);
    [soundsArray release];
    [player release];
    [tableView release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*soundsArray = [[NSArray alloc] initWithObjects:@"Ascending", @"Bell", @"Bell 1", @"Chime", @"Chime 1", @"Crickets", @"Duck", @"Guitar", @"Harp", @"Sparrow", @"Trill",@"Vibraphone",@"Water Glass",nil];*/
    soundsArray = [[NSArray alloc] initWithObjects:
                   @"Twilight Piano",
                   @"Study Mix",
                   @"Morning Piano Nature",
                   @"Gamma brainwaves",
                   @"Morning Glow",
                   @"Vibrate",
                   @"Love",
                   @"Because of You",
                   @"Alarm Chicken",
                   @"3 Beeps",
                   nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setTableView:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Select Alarm Tone";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    player.delegate = nil;
    
    if([player isPlaying]){
        [player stop];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [soundsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([selectedString isEqualToString:[soundsArray objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    [cell.textLabel setText:[soundsArray objectAtIndex:indexPath.row]];
    
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if([player isPlaying]){
		[player stop];
		player = nil;
	}
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedString = [soundsArray objectAtIndex:indexPath.row];
    
    [self.tableView reloadData];
    
    //dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	//dispatch_async(concurrentQueue, ^{
    NSString *path = [[NSBundle mainBundle] pathForResource:selectedString ofType:@"wav"];
    
    // playing sound using AVAudioPlayer
    
    /*NSError *error = nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    player.delegate = self;
    
    [player prepareToPlay];
    
    [player play];*/
    //});
    if ([selectedString isEqualToString:@"Vibrate"]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    //Playing Sound Using System soundID
    AudioServicesDisposeSystemSoundID(_alarmSoundId);
    NSURL *alarmSoundURL = [NSURL fileURLWithPath:path];
	AudioServicesCreateSystemSoundID((CFURLRef)alarmSoundURL, &_alarmSoundId);
    AudioServicesPlaySystemSound(_alarmSoundId);
    NSLog(@"I'm vibrating");

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [delegate didFinishSelectingAlarmWithSelectedAlarm:self.selectedString];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [delegate didCancelSelectingAlarm];
}
@end

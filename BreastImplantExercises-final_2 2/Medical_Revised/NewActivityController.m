//
//  NewActivityController.m
//  Medical
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "NewActivityController.h"
#import "AppDelegate.h"

@implementation NewActivityController
@synthesize tableView = _tableView;
@synthesize navBar = _navBar;
@synthesize toolBar = _toolBar;
@synthesize textView;
@synthesize activities;
@synthesize myView;
@synthesize ExerciseName, tubeURL;
@synthesize isRapidReturn;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	self.toolBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	[self.myView setFrame:CGRectMake(0, -100, 320, 44)];
	[self.myView addSubview:self.toolBar];
	
	NSArray *myArray = [[NSArray alloc]initWithObjects:@"Exercise Name :", @"Video URL :", @"Description :", nil];
	self.activities = [[NSMutableArray alloc] initWithArray:myArray];
	[myArray release];
	
     //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	self.navBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navBar.topItem.titleView = label;
	label.text = NSLocalizedString(@"Add New Exercise", @"");
	[label sizeToFit];
	
	UIBarButtonItem *cancelbtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector (cancelAction:)];
	self.navBar.topItem.leftBarButtonItem = cancelbtn;
	
	UIBarButtonItem *savebtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector (saveAction:)];
	self.navBar.topItem.rightBarButtonItem = savebtn;
	
	[super viewDidLoad];
	
}


-(void)cancelAction:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.75];
	
	CGRect frame = self.textView.frame;
	frame.origin.y = 0;
	self.textView.frame = frame;
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
	[self dismissModalViewControllerAnimated:YES];
	
	
}

-(void)saveAction:(id)sender {
	
	AppDelegate *appDelgate = [AppDelegate appDelegate];
    
    if(isRapidReturn){
        [appDelgate insertNewActivityInRapidReturn:ExerciseName.text videoURL:tubeURL.text eDiscription:textView.text];
    }
    else{
        [appDelgate insertNewActivityINBreastMassage:ExerciseName.text videoURL:tubeURL.text eDiscription:textView.text];
    }
	
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.allowsSelection = NO;
	CGRect labelFrame = CGRectMake(5, 10, 290, 25);
	UILabel * lblTemp = [[UILabel alloc] initWithFrame:labelFrame];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.text = [self.activities objectAtIndex:indexPath.row];
	lblTemp.font = [UIFont fontWithName:@"Marker Felt" size:17];
	lblTemp.textColor = [UIColor whiteColor];
	
	switch (indexPath.row) {
		case 0:{
			
			ExerciseName = [[UITextField alloc] initWithFrame:CGRectMake(130, 8, 170, 25)];
			ExerciseName.borderStyle = UITextBorderStyleRoundedRect;
			ExerciseName.textColor = [UIColor whiteColor];
			ExerciseName.font = [UIFont systemFontOfSize:14.0];
			ExerciseName.placeholder = @"Exercise Name";
			ExerciseName.backgroundColor = [UIColor grayColor];
			ExerciseName.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
			ExerciseName.keyboardType = UIKeyboardTypeAlphabet;	// use the default type input method (entire keyboard)
			ExerciseName.delegate = self;
			ExerciseName.clearButtonMode = UITextFieldViewModeWhileEditing;// has a clear 'x' button to the right
			ExerciseName.returnKeyType = UIReturnKeyDone;
			[cell addSubview:ExerciseName];
			
		}break;
		case 1:{
			
			tubeURL = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 25)];
			tubeURL.borderStyle = UITextBorderStyleRoundedRect;
			tubeURL.textColor = [UIColor whiteColor];
			tubeURL.font = [UIFont systemFontOfSize:14.0];
			tubeURL.placeholder = @"Video Url";
			tubeURL.backgroundColor = [UIColor grayColor];
			tubeURL.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
			tubeURL.keyboardType = UIKeyboardTypeAlphabet;	// use the default type input method (entire keyboard)
			tubeURL.delegate = self;
			tubeURL.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
			tubeURL.returnKeyType = UIReturnKeyDone;
			[cell addSubview:tubeURL];
			
		}break;
		case 2: {
			
			self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 35, 280, 150)];
			[self.textView setTextColor:[UIColor whiteColor]];
			[self.textView setBackgroundColor:[UIColor grayColor]];
			[self.textView setTextAlignment:UITextAlignmentLeft];
			[self.textView.layer setCornerRadius:8.0];
			self.textView.layer.borderColor = [UIColor colorWithRed:0.102 green:0.235 blue:0.384 alpha:1].CGColor;
			self.textView.layer.borderWidth = 4.0;
			self.textView.delegate = self;
			self.textView.returnKeyType = UIReturnKeyDefault;
			[cell addSubview:textView];
			
		}break;
		default:
			break;
	}
	
	return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	CGRect frame = self.myView.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	frame.origin.y = 210;
	self.myView.frame = frame;
	self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 210.0), self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
	return YES;
}

-(IBAction)hideKeyBoard {
	
	CGRect frame = self.myView.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 210.0), self.view.frame.size.width, self.view.frame.size.height);
	frame.origin.y = -100;
	self.myView.frame = frame;
	[UIView commitAnimations];
	[self.textView resignFirstResponder];
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0: return 42;
			break;
		case 1: return 160;
			break;
		case 2: return 190;
			break;
	}
	return 0;
	
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
    self.ExerciseName = nil;
    self.tubeURL = nil;
    self.textView = nil;
}


- (void)dealloc {
    
    [ExerciseName release];
    [tubeURL release];
    [textView release];
    
    
	[super dealloc];
}


@end


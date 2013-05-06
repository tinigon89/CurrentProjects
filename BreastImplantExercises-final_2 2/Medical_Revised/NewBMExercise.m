//
//  NewBMExercise.m
//  Medical
//
//  Created by Mac Mni on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewBMExercise.h"
#import "AppDelegate.h"

@implementation NewBMExercise
@synthesize isEditMode;
@synthesize exercise;
@synthesize segmentedControl;

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
    [exercise release];
    [segmentedControl release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIBarButtonItem *saveBtn = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)] autorelease];
    
    [self.navigationItem setRightBarButtonItem:saveBtn];
    
    UIBarButtonItem *cancelBtn = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)save:(id)sender{
    AppDelegate *appDelgate = [AppDelegate appDelegate];
    
    NSString *exerciseName;
    if([segmentedControl selectedSegmentIndex] == 0){
        exerciseName = @"Exercise-Left";
    }

    else if([segmentedControl selectedSegmentIndex] == 1){
        exerciseName = @"Exercise-Right";
    }

    
    [appDelgate insertNewActivityINBreastMassage:exerciseName videoURL:@"http://www.google.com" eDiscription:@"Description Goes Here"];
	
	
	[self dismissModalViewControllerAnimated:YES];
}
-(void)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  //  self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.141 green:0.357 blue:0.380 alpha:1];
    
     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Marker Felt" size:20];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = label;
	


    if (!isEditMode) {
    label.text = NSLocalizedString(@"New Exercise ", @"");    
    }
    else{
        
    }
    	[label sizeToFit];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  CustomExerciseController.m
//  Medical
//
//  Created by Mac Mni on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomExerciseController.h"

@implementation CustomExerciseController
@synthesize exercise;
@synthesize descriptionView;
@synthesize videoView;

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
    [videoView release];
    [descriptionView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"name: %@ , desc: %@ , url: %@",exercise.name,exercise.description,exercise.tubeURL);
    [self.descriptionView setText:exercise.description];
    
    CGRect frame = videoView.frame;
    frame.origin.y = frame.origin.y + 21;
    
    
    [self embedYouTube:exercise.tubeURL frame:frame];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.102 green:0.225 blue:0.404 alpha:1];	
    
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
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.videoView = nil;
    self.descriptionView = nil;
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


@end

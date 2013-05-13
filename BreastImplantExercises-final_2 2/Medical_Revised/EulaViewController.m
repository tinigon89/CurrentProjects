//
//  EulaViewController.m
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/8/13.
//
//

#import "EulaViewController.h"

@interface EulaViewController ()

@end

@implementation EulaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *localFile = @"Terms of User";
    NSString *aboutPath =[[NSBundle mainBundle] pathForResource:localFile ofType:@"pdf"];
    NSURL *	url = [[NSURL alloc] initFileURLWithPath: aboutPath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [self.webView loadRequest: request];
    self.webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)accept_Click:(id)sender
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"FirstTime"];
    [self dismissModalViewControllerAnimated:YES];
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

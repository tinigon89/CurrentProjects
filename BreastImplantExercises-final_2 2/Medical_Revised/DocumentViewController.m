//
//  DocumentViewController.m
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/19/13.
//
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

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
    NSString *localFile = self.document;
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
- (IBAction)close_Click:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end

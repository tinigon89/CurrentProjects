//
//  PhaseHelpViewController.m
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/12/13.
//
//

#import "PhaseHelpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
@interface PhaseHelpViewController ()

@end

@implementation PhaseHelpViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // grab an image of our parent view
    UIView *parentView = self.presentingViewController.view;
    
    // For iOS 5 you need to use presentingViewController:
    // UIView *parentView = self.presentingViewController.view;
    
    UIGraphicsBeginImageContext(parentView.bounds.size);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // insert an image view with a picture of the parent view at the back of our view's subview stack...
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    CGRect frame = imageView.frame;
    frame.origin.y -=20;
    frame.size.height +=20;
    imageView.frame = frame;
    imageView.image = parentViewImage;
    [self.view insertSubview:imageView atIndex:0];
    [imageView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_hide release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHide:nil];
    [super viewDidUnload];
}
- (IBAction)hideView:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:KPhaseHelp];
    [userDefault synchronize];
    [self dismissModalViewControllerAnimated:NO];
}
@end

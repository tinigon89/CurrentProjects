//
//  UINavigationController+autorotate.m
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/13/13.
//
//
#import <UIKit/UIKit.h>
#import "UINavigationController+autorotate.h"

@implementation UINavigationController (autorotate)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return [self.visibleViewController shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations
{
    if (![[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"ViewController")])
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return [self.topViewController supportedInterfaceOrientations];
    }
}
@end

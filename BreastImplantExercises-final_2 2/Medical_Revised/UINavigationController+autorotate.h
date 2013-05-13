//
//  UINavigationController+autorotate.h
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/13/13.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (autorotate)
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end

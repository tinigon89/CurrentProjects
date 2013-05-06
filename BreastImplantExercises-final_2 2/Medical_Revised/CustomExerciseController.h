//
//  CustomExerciseController.h
//  Medical
//
//  Created by Mac Mni on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface CustomExerciseController : UIViewController
{

    Exercise *exercise;
    UIView *videoView;
    UITextView *descriptionView;
}
@property(nonatomic , retain) Exercise *exercise;
@property(nonatomic , retain) IBOutlet UIView *videoView;
@property(nonatomic , retain) IBOutlet UITextView *descriptionView;

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;
@end

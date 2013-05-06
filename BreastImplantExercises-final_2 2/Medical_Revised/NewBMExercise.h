//
//  NewBMExercise.h
//  Medical
//
//  Created by Mac Mni on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
@interface NewBMExercise : UIViewController
{

    BOOL isEditMode;
    Exercise *exercise;
    UISegmentedControl *segmentedControl;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    
    
    
}
@property(nonatomic , retain) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic , readwrite) BOOL isEditMode;
@property(nonatomic , retain) Exercise *exercise;

@end

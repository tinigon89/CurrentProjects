//
//  BreastMassageController.h
//  Medical
//
//  Created by Mac Mni on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Exercise.h"
@interface BreastMassageController : UIViewController<UITableViewDelegate , UITableViewDataSource>
{
    
    UIView *phaseView;
	UIView *videoView;
    UIView *instructionView;
    NSMutableArray *exerciseArray;
    IBOutlet UISwitch *mainSwitch;
    
}
@property (nonatomic, retain) NSMutableArray *exerciseArray;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *phaseView;
@property (nonatomic, retain) IBOutlet UIView *videoView;
@property (nonatomic, retain) IBOutlet UIView *instructionView;

- (IBAction)showInstruction:(id)sender;
- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;
- (IBAction)mainSwitchValueChanged:(id)sender;
- (void)scheduleNotificationForIndexOfExercise:(int)indexOfExercise;

@end

//
//  RapidReturnController.h
//  Medical
//
//  Created by Askone on 3/14/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RapidReturnController : UIViewController {

	IBOutlet UIView *phaseView;
	IBOutlet UIView *videoView;
	IBOutlet UIView *execeriseDetails;
	IBOutlet UIView *settingsView;
    IBOutlet UISwitch *mainSwitch;
	
	UITableView *_tableView;
    NSMutableArray *exerciseArray;
	
}
@property (retain, nonatomic) IBOutlet UIWebView *videoWebView;
@property (nonatomic, retain) NSMutableArray *exerciseArray;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIView *phaseView;
@property (nonatomic, retain) UIView *videoView;
@property (nonatomic, retain) UIView *execeriseDetails;
@property (nonatomic, retain) UIView *settingsView;

- (IBAction)showInstruction:(id)sender;
- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;
- (IBAction)mainSwitchValueChanged:(id)sender;

- (void)scheduleNotificationForIndexOfExercise:(int)indexOfExercise;

@end

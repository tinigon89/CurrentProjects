//
//  ShoulderRollController.h
//  Medical
//
//  Created by Askone on 3/26/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Exercise.h"
#import "AlarmControllerDelegate.h"
@interface NewBMExerciseController : UIViewController <UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource , AlarmControllerDelegate>{


	IBOutlet UIView *settingsView;
	
	IBOutlet UIButton *startBtn;
	IBOutlet UIButton *endBtn;
	IBOutlet UIButton *frequncyBtn;
    IBOutlet UISegmentedControl *segmentedControl;
	IBOutlet UISwitch *mainSwitch;
	
	IBOutlet UINavigationBar *textNavBar;
	
	IBOutlet UIView *customView;
	UITableView *_tableView;
	
	int buttonActive;
	IBOutlet UITextField *textfield;
	
	NSMutableArray *intervalArray;
    
    Exercise *exercise;
    int index;
    
    NSString *alarmString;
    
    UIBarButtonItem *doneButtonItem;// to enable and disable done button on main switch
    
    
    
    
	
	
}
@property(nonatomic , retain)  NSString *alarmString;
@property (retain, nonatomic) IBOutlet UIButton *btnSelectAlarm;
@property (nonatomic, readwrite) int index;
@property (nonatomic, retain) NSMutableArray *intervalArray;
@property (nonatomic, retain) UIBarButtonItem *doneButtonItem;

@property (nonatomic, retain)UITextField *textfield;
@property (nonatomic, retain)UINavigationBar *textNavBar;
@property (nonatomic, retain)UIView *customView;
@property (nonatomic, retain)UITableView *tableView;


@property (nonatomic, retain)UIView *settingsView;

@property (nonatomic, retain)UIButton *startBtn;
@property (nonatomic, retain)UIButton *endBtn;
@property (nonatomic, retain)UIButton *frequncyBtn;

@property (nonatomic, retain)UISwitch *mainSwitch;

@property(nonatomic , retain) Exercise *exercise;


-(IBAction)buttonPressed:(id)sender;
-(IBAction)doneEditing:(id)sender;
-(IBAction)mainSwitchValueChanged:(id)sender;

- (IBAction)selectAlarmButtonPressed:(UIButton *)sender;

-(void)activateExercise;
-(void)loadSettings;
-(void)scheduleAlarms;

@end

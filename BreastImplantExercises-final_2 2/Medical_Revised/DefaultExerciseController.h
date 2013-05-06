//
//  DefaultExerciseController.h
//  Medical
//
//  Created by Askone on 3/26/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Exercise.h"
#import "AlarmControllerDelegate.h"
@interface DefaultExerciseController : UIViewController 
<UITextFieldDelegate,UITableViewDelegate, 
UITableViewDataSource , AlarmControllerDelegate,UIActionSheetDelegate>{


	IBOutlet UIView *settingsView;
	
	IBOutlet UIButton *startBtn;
	IBOutlet UIButton *endBtn;
	IBOutlet UIButton *frequncyBtn;
	IBOutlet UISwitch *mainSwitch;
	IBOutlet UINavigationBar *textNavBar;
	IBOutlet UIView *customView;
    
	UITableView *_tableView;
	
	int buttonActive;
	IBOutlet UITextField *textfield;
	
	NSMutableArray *intervalArray;
    NSMutableArray *intervalNumArray;
    //NSString *alarmString;
    Exercise *exercise;
    int index;
    NSUserDefaults *userDefault;
    
    UIBarButtonItem *doneButtonItem;// to enable and disable done button on main switch
	NSString *dictionaryKey;
	NSString *leftSound;
    NSString *rightSound;
    NSString *leftFreq;
    NSString *rightFreq;
    BOOL isLeft;
    NSDate *leftStartDay;
    NSDate *leftEndDay;
    NSDate *rightStartDay;
    NSDate *rightEndDay;
    
    UIDatePicker *picker;
    UIActionSheet *actionsheet;
    BOOL isEndDay;
}
- (IBAction)switchValueChanged:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnSelectAlarm;
//@property (nonatomic, retain) NSString *alarmString;
@property (nonatomic, retain) UIBarButtonItem *doneButtonItem;
@property (nonatomic, readwrite) int index;
@property (nonatomic, retain)NSMutableArray *intervalArray;
@property (nonatomic, retain)NSMutableArray *intervalNumArray;
@property (nonatomic, retain)UITextField *textfield;
@property (nonatomic, retain)UINavigationBar *textNavBar;
@property (nonatomic, retain)UIView *customView;
@property (nonatomic, retain)UITableView *tableView;


- (IBAction)selectAlarmButtonPressed:(UIButton *)sender;

@property (nonatomic, retain)UIView *settingsView;

@property (nonatomic, retain)UIButton *startBtn;
@property (nonatomic, retain)UIButton *endBtn;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain)UIButton *frequncyBtn;
@property (nonatomic, retain)UISwitch *mainSwitch;

@property(nonatomic , retain) Exercise *exercise;

-(IBAction)buttonPressed:(id)sender;
-(IBAction)doneEditing:(id)sender;
-(IBAction)mainSwitchValueChanged:(id)sender;
//-(void)activateExercise;
-(void)loadSettings;
-(void)scheduleAlarms:(BOOL)rightSide;


@end

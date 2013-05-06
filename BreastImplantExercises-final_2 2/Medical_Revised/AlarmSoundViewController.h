//
//  AlarmSoundViewController.h
//  Medical_Revised
//
//  Created by Mac Mni on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AlarmControllerDelegate.h"
@interface AlarmSoundViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , AVAudioPlayerDelegate>
{

    NSArray *soundsArray;
    NSString *selectedString;
    AVAudioPlayer *player;
    UITableView *tableView;
    SystemSoundID _alarmSoundId;
    
    id<AlarmControllerDelegate>delegate;
    
}
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
@property (nonatomic , assign) id<AlarmControllerDelegate>delegate;
@property (nonatomic , retain) IBOutlet UITableView *tableView;
@property (nonatomic , retain) AVAudioPlayer *player;
@property (nonatomic , retain) NSArray *soundsArray;
@property (nonatomic , retain) NSString *selectedString;
@end

//
//  Constants.h
//  Medical
//
//  Created by CyberDesignz on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KRapidReturnArray @"Array" 
#define KBreastMassageArray @"Array2"

// index 0  for Shoulder Roll
// index 1 for Arm Circles
// index 2 for Arm Stretch

#define KDays @"days"
#define KFrequency @"frequency"
#define KIsOn @"isOn"
#define KStartDays @"EndDays" // specially for BMExercise
#define KLocalNotification @"Notification"  //Saves UILocalNotifation archived in NSData
#define KPhaseHelp @"PhaseHelp" 
#define KExerciseHelp @"ExerciseHelp" 

#define KIsLeft @"isLeft"
#define KLeftSound @"LeftSound"
#define KRightSound @"RightSound"
#define KLeftFrequency @"LeftFrequency"
#define KRightFrequency @"RightFrequency"
#define KLeftStartDays @"LeftStartDays" // specially for BMExercise
#define KLeftEndDays @"LeftEndDays" // specially for BMExercise
#define KLeftStartTime @"LeftStartTime" // specially for BMExercise
#define KLeftEndTime @"LeftEndTime" // specially for BMExercise
#define KRightStartTime @"RightStartTime" // specially for BMExercise
#define KRightEndTime @"RightEndTime" // specially for
#define KRightStartDays @"RightStartDays" // specially for BMExercise
#define KRightEndDays @"RightEndDays" // specially for BMExercise
#define KLeftLocalNotification @"LeftNotification"
#define KRightLocalNotification @"RightNotification"//Saves UILocalNotifation archived in NSData

#define KIsRapidReturnOn @"RapidReturnOn"
#define KIsBreastMassageOn @"BreastMassageOn"



// For UILocalNotification , In app Alert
#define KAlertName @"AlertName"
#define KAlertType @"AlertType"

#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define PORTRAIT_KEYBOARD_HEIGHT 216
#define LANDSCAPE_KEYBOARD_HEIGHT  162
#else
#define IS_IPAD() (false)
#define PORTRAIT_KEYBOARD_HEIGHT 216
#define LANDSCAPE_KEYBOARD_HEIGHT  162
#endif

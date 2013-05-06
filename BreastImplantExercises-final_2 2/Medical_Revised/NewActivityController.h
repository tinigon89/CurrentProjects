//
//  NewActivityController.h
//  Medical
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NewActivityController : UIViewController <UITextFieldDelegate, UITextViewDelegate>{

	UITableView *_tableView;
	NSMutableArray *Activities;
	UINavigationBar *_navBar;
	UITextView *textView;
	UIToolbar *_toolBar;
	
	IBOutlet UIView *myView;
	
	UITextField *ExerciseName;
	UITextField *tubeURL;
    BOOL isRapidReturn;
	
}
@property(nonatomic , readwrite) BOOL isRapidReturn;
@property (nonatomic, retain)UITextField *ExerciseName;
@property (nonatomic, retain)UITextField *tubeURL;
@property (nonatomic, retain)IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *activities;


@property (nonatomic, retain)IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain)UIView *myView;
@property (nonatomic, retain)UITextView *textView;

-(IBAction)hideKeyBoard;

@end

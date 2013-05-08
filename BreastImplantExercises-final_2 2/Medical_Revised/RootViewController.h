//
//  RootViewController.h
//  Medical
//
//  Created by Askone on 3/14/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKLocalNotificationsScheduler.h"

@interface RootViewController : UIViewController {
	
	//UITableView *_tableView;
	IBOutlet UIButton *button1;
	IBOutlet UIButton *button2;
    BOOL isShowDisclaim;
    
}
@property (nonatomic, retain)UIView *DisclaimerView;

-(IBAction)pushButton:(id)sender;


@end

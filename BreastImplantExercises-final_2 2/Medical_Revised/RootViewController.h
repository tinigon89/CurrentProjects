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
    
}
@property (retain, nonatomic) IBOutlet UIView *eulaVIew;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain)UIView *DisclaimerView;
- (IBAction)accept_Clicked:(id)sender;

-(IBAction)pushButton:(id)sender;


@end

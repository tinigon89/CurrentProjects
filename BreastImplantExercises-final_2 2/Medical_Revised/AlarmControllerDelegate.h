//
//  AlarmControllerDelegate.h
//  PlacikProtocol
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlarmControllerDelegate <NSObject>

-(void)didCancelSelectingAlarm;
-(void)didFinishSelectingAlarmWithSelectedAlarm:(NSString *)selectedAlarmString;

@end

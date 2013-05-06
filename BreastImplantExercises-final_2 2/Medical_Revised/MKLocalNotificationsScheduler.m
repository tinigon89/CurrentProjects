//
//  MKLocalNotificationsScheduler.m
//  LocalNotifs
//
//  Created by Mugunth Kumar on 9-Aug-10.
//  Copyright 2010 Steinlogic. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "MKLocalNotificationsScheduler.h"
#import "AppManager.h"

static MKLocalNotificationsScheduler *_instance;
@implementation MKLocalNotificationsScheduler

@synthesize badgeCount = _badgeCount;
+ (MKLocalNotificationsScheduler*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
			// iOS 4 compatibility check
			Class notificationClass = NSClassFromString(@"UILocalNotification");
			
			if(notificationClass == nil)
			{
				_instance = nil;
			}
			else 
			{				
				_instance = [[super allocWithZone:NULL] init];				
				_instance.badgeCount = 0;
			}
        }
    }
    return _instance;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
   return [[self sharedInstance] retain];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}



- (id)autorelease
{
    return self;	
}

- (void) schedulePhaseTwoNotificationOn:(NSDate*) fireDate
                                   text:(NSString*) alertText
                                 action:(NSString*) alertAction
                                  sound:(NSString*) soundfileName
                            launchImage:(NSString*) launchImage
                                andInfo:(NSDictionary*) userInfo


{   UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
	localNotification.repeatInterval = NSHourCalendarUnit;
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
	localNotification.soundName = @"Alarm Chicken.wav";
	localNotification.alertLaunchImage = launchImage;
	NSDictionary *alarmname = [NSDictionary dictionaryWithObject:@"Daily_alarm" forKey:@"kTimerNameKey"];
    localNotification.userInfo = alarmname;
    localNotification.userInfo = userInfo;
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}


- (void) scheduleNotificationOn:(NSDate*) fireDate
								text:(NSString*) alertText
								action:(NSString*) alertAction
								 sound:(NSString*) soundfileName
						   launchImage:(NSString*) launchImage 
							   andInfo:(NSDictionary*) userInfo
						

{   UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];	
	localNotification.repeatInterval = NSHourCalendarUnit;
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;	
	localNotification.soundName = @"Alarm Chicken.wav";
	localNotification.alertLaunchImage = launchImage;
	NSDictionary *alarmname = [NSDictionary dictionaryWithObject:@"Daily_alarm" forKey:@"kTimerNameKey"];
    localNotification.userInfo = alarmname;
    localNotification.userInfo = userInfo;
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;			
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

- (void) clearBadgeCount
{
	self.badgeCount = 0;
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) decreaseBadgeCountBy:(int) count
{
	self.badgeCount -= count;
	if(self.badgeCount < 0) self.badgeCount = 0;
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	NSLog(@"Received: %@",[thisNotification description]);
    [self decreaseBadgeCountBy:1];
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:40];
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//	localNotification.repeatInterval = NSDayCalendarUnit;
//    //localNotification.alertBody = alertText;
//    //localNotification.alertAction = alertAction;
//	
//    localNotification.soundName = @"Alarm Chicken.wav";
//		self.badgeCount ++;
//    localNotification.applicationIconBadgeNumber = self.badgeCount;
//    // Schedule it with the app
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    [localNotification release];
	
}

@end

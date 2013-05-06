//
//  MedicalAppDelegate.h
//  Medical
//
//  Created by Askone on 3/14/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	sqlite3 *database;
    NSString *databasePath;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) UINavigationController *navigationController;

+(AppDelegate *)appDelegate;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;
-(void)init_sql;

-(NSArray *)readRapidReturnExercisesFromDatabase;
-(NSArray *)readBreastMassageExercisesFromDatabase;
-(BOOL)insertNewActivityINBreastMassage:(NSString *)name videoURL:(NSString*)url eDiscription:(NSString *)desc;
-(BOOL)insertNewActivityInRapidReturn:(NSString *)name videoURL:(NSString*)url eDiscription:(NSString *)desc;
-(BOOL)resetDatabase;

-(void)showNotificationAlert:(UILocalNotification *)notif;
-(void)setDefaultSettingsExercise;

@end
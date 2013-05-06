//
//  AppDelegate.m
//  Medical_Revised
//
//  Created by Mac Mni on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Exercise.h"
#import "Constants.h"
#import "MKLocalNotificationsScheduler.h"

//static NSString *DatabaseFileName£ = @"ExercisesDatabase.sqlite";
static NSString *DatabaseFileName = @"SampleDatabase.sqlite";

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;
@synthesize databasePath;

- (void)dealloc
{
    [_window release];
    [navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self copyDatabaseIfNeeded];
    [self init_sql];
    databasePath = [[self getDBPath] retain];
    
    //[self resetDatabase];
    
    [self setDefaultSettingsExercise];
    
    //[self readExercisesFromDatabase];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //UILocalNotification *localNotif =
//    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (localNotif) {
//        //self.currentUserInfo = localNotif.userInfo;
//        //[self showNotificationAlert:localNotif];
//    }
//    //[self showSnoozeScreen];
//    
    
    RootViewController *rootController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstTime = [userDefaults boolForKey:@"FirstTime"];
    if (!firstTime) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Announcement"
                              message: @"The App is intended for persons eighteen (18) years or older. Persons under the age of eighteen (18) should not access, use and/or browse the App unless under the immediate supervision of an adult.!"
                              delegate: nil
                              cancelButtonTitle:nil
                              
                              otherButtonTitles:nil];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Confirm"];
        [alert addButtonWithTitle:@"Cancel"];
        
        [alert show];
        [alert release];

    }
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification)
	{
		[[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:localNotification];
    }
    
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        //confirm
    }
	else if (buttonIndex == 1)
	{
        exit(0);
		
	}
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)localNotification {
    
	[[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:localNotification];
}
-(void)showNotificationAlert:(UILocalNotification *)notif{
    NSDictionary *userInfo = [notif userInfo];
    NSString *alertTitle = [userInfo objectForKey:KAlertType];
    //NSString *exerciseName = [userInfo objectForKey:KAlertName];
    
    NSString *alertBody = [NSString stringWithFormat:@"%@",notif.alertBody];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
    
}



-(void)setDefaultSettingsExercise{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:KRapidReturnArray]) {
        NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        NSMutableDictionary *shoulderRoll = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *armCircles = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *armStretch = [[[NSMutableDictionary alloc] init] autorelease];
        
        [shoulderRoll setValue:[NSNumber numberWithInt:3] forKey:KDays];
        [shoulderRoll setValue:@"1 Hour" forKey:KFrequency];
        [shoulderRoll setValue:[NSNumber numberWithBool:NO] forKey:KIsOn];
        [shoulderRoll setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
        
        [armCircles setValue:[NSNumber numberWithInt:3] forKey:KDays];
        [armCircles setValue:@"1 Hour" forKey:KFrequency];
        [armCircles setValue:[NSNumber numberWithBool:NO] forKey:KIsOn];
        [armCircles setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
        
        [armStretch setValue:[NSNumber numberWithInt:3] forKey:KDays];
        [armStretch setValue:@"1 Hour" forKey:KFrequency];
        [armStretch setValue:[NSNumber numberWithBool:NO] forKey:KIsOn];
        [armStretch setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
        
        [array addObject:shoulderRoll];
        [array addObject:armCircles];
        [array addObject:armStretch];
        
        [defaults setValue:array forKey:KRapidReturnArray];
        [defaults synchronize];
        
    }
    
    if(![defaults objectForKey:KBreastMassageArray]){
        
        // Now for Breast Massage Defaults
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 6; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"8 Hours" forKey:KFrequency];
            [dict setValue:[NSNumber numberWithBool: NO] forKey:KIsOn];
            [dict setValue:[NSNumber numberWithBool:NO] forKey:KIsLeft];
            [dict setValue:[NSNumber numberWithInt:3] forKey:KStartDays];
            [dict setValue:[NSNumber numberWithInt:90] forKey:KDays];
            
            [array addObject:dict];
            [dict release];
            
        }
        [defaults setValue:array forKey:KBreastMassageArray];
        [defaults synchronize];
        [array release];
    }
    
    
    
}

+(AppDelegate *)appDelegate{
	
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
	
}

#pragma mark sqlite methods
- (void) copyDatabaseIfNeeded 
{
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DatabaseFileName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseFileName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        // NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        NSLog(@"%@",[error description]);
    }
}

- (NSString *) getDBPath 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	NSString *test_path = [documentsDir stringByAppendingPathComponent:DatabaseFileName];
	//NSLog(@"%@",test_path);
	
	return test_path;
	
}
-(void)init_sql{
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:DatabaseFileName];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK){
        NSLog(@"Database opened Successfully");
    }
    else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}




-(NSArray *)readRapidReturnExercisesFromDatabase{
	
	//sqlite3 *database;
	NSMutableArray *exercisesArray = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *compiledStatement;
    //NSLog(@"dbpath %@",databasePath);
    if (sqlite3_open([databasePath UTF8String], &database)== SQLITE_OK) {
		const char *sqlStatement = "SELECT name,description,video_url,id FROM exercise";
		
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)== SQLITE_OK) {
			while (sqlite3_step(compiledStatement)== SQLITE_ROW) {
				
				NSString *aName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
				NSString *aDescr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                 NSInteger aId = sqlite3_column_int(compiledStatement, 3);
				//NSLog(@"Name: %@ , Desc: %@ , URL: %@",aName,aDescr,aURL);
				
                Exercise *execerise = [[Exercise alloc] initWithId:aId Name:aName description:aDescr youTube:aURL];
				[exercisesArray addObject:execerise];
				[execerise release];
				
			}
        }
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
    
    return exercisesArray;
    
}
-(BOOL)insertNewActivityInRapidReturn:(NSString *)name videoURL:(NSString*)url eDiscription:(NSString *)desc {
    
    BOOL flag = NO;
    sqlite3_stmt    *statement;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        //NSString *insert_stmt_user = [NSString stringWithFormat:@"insert or ignore into user values('%@')",xmpp_id];
        NSString *insert_stmt_message = [NSString stringWithFormat:
                                         @"insert into exercise (name , description , video_url) values('%@' , '%@' , '%@')",
                                         name , desc , url];
        
        const char *insert_stmt = [insert_stmt_message UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //NSLog(@"Inserted");
            flag = YES;
            
        } 
        else {
            //status.text = @"Failed to add contact";
            flag = NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return flag;
    
}

-(NSArray *)readBreastMassageExercisesFromDatabase{
	
	//sqlite3 *database;
	NSMutableArray *exercisesArray = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *compiledStatement;
    //NSLog(@"dbpath %@",databasePath);
    if (sqlite3_open([databasePath UTF8String], &database)== SQLITE_OK) {
		const char *sqlStatement = "SELECT name,description,url,id FROM BMExercise";
		
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)== SQLITE_OK) {
			while (sqlite3_step(compiledStatement)== SQLITE_ROW) {
				
				NSString *aName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
				NSString *aDescr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				
				NSInteger aId = sqlite3_column_int(compiledStatement, 3);
				//NSLog(@"Name: %@ , Desc: %@ , URL: %@",aName,aDescr,aURL);
				
                Exercise *execerise = [[Exercise alloc] initWithId:aId Name:aName description:aDescr youTube:aURL];
				[exercisesArray addObject:execerise];
				[execerise release];
				
			}
        }
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
    
    return exercisesArray;
    
}
-(BOOL)insertNewActivityINBreastMassage:(NSString *)name videoURL:(NSString*)url eDiscription:(NSString *)desc {
    
    BOOL flag = NO;
    sqlite3_stmt    *statement;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        //NSString *insert_stmt_user = [NSString stringWithFormat:@"insert or ignore into user values('%@')",xmpp_id];
        NSString *insert_stmt_message = [NSString stringWithFormat:
                                         @"insert into BMExercise (name , description , url) values('%@' , '%@' , '%@')",
                                         name , desc , url];
        
        const char *insert_stmt = [insert_stmt_message UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //NSLog(@"Inserted");
            flag = YES;
            
        } 
        else {
            //status.text = @"Failed to add contact";
            flag = NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return flag;
    
}
-(BOOL)resetDatabase{
    BOOL flag = NO;
    sqlite3_stmt    *statement;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"delete from exercise;"];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(database, delete_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"History Cleared Successfully");
            
        } 
        else {
            //status.text = @"Failed to add contact";
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    
    
    
    return flag;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end

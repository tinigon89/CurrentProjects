//
//  AppManager.m
//  PlacikProtocol
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "AppManager.h"
static AppManager *sharedInstance;

@implementation AppManager
@synthesize intervalsArray,intervalsNumArray;

-(id)init
{
    self = [super init]; 
    if (self) {
        intervalsArray = [[NSArray alloc] initWithObjects:@"Nerver",@"30 Minutes", @"1 Hour", @"2 Hours", @"3 Hours",
                          @"4 Hours", @"5 Hours", @"6 Hours", @"7 Hours", @"8 Hours", @"9 Hours", @"10 Hours",
                          @"11 Hours", @"12 Hours", nil];
        intervalsNumArray = [[NSArray alloc] initWithObjects:@"0",@"0.5", @"1", @"2", @"3",
                          @"4", @"5", @"6", @"7", @"8", @"9", @"10",
                          @"11", @"12", nil];
    }
    return self;
}
+(AppManager *)sharedInstance
{
    if(!sharedInstance){
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

@end

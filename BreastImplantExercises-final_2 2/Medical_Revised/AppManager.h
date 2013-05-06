//
//  AppManager.h
//  PlacikProtocol
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject{
    NSArray *intervalsArray;
    NSArray *intervalsNumArray;
}
@property(nonatomic , retain) NSArray *intervalsArray;
@property(nonatomic , retain) NSArray *intervalsNumArray;
+(AppManager *)sharedInstance;

@end

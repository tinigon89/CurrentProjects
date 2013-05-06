//
//  Exercises.h
//  Medical
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Exercise : NSObject {

	NSString *name;
	NSString *tubeURL;
	NSString *description;

    NSInteger exerciseId;
}

@property (nonatomic)NSInteger exerciseId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *tubeURL;
@property (nonatomic, retain)NSString *description;

//-(id)initWithName:(NSString *)n description:(NSString *)d youTube:(NSString *)url;
//-(id)insertRecords:(NSString *)n description:(NSString *)d youTube:(NSString *)url;
-(id)initWithId:(NSInteger)exId Name:(NSString *)n description:(NSString *)d youTube:(NSString *)url;


@end

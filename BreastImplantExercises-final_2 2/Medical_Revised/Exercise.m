//
//  Exercises.m
//  Medical
//
//  Created by Askone on 3/20/12.
//  Copyright 2012 askone. All rights reserved.
//

#import "Exercise.h"

@implementation Exercise
@synthesize name, tubeURL, description,exerciseId;


-(id)initWithId:(NSInteger)exId Name:(NSString *)n description:(NSString *)d youTube:(NSString *)url
{
	self.exerciseId = exId;
	self.name = n;
	self.tubeURL = url;
	self.description = d;
	return self;
}

/*
-(id)insertRecords:(NSString *)n description:(NSString *)d youTube:(NSString *)url{
	
	self.name = n;
	self.tubeURL = url;
	self.description = d;
	return self;
}*/



@end

//
//  Mission.h
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event, EventNode;

@interface Mission : NSObject
@property EventNode* RootNode;
-(id)initWithEventRoot:(EventNode*)rootNode;
-(void)missionTimerTick:(long)timeInHundredMs;
-(void)missionDistanceChanged:(float)distanceInMeters;
@property NSMutableArray* globalEventList; //we have events that happen whenever a user reaches a milestone - such as a certain distance or speed.
//need to constantly monitor for these.
@end

//
//  Mission.m
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "Mission.h"
#import "Event.h"
#import "Task.h"
#import "EventNode.h"

@interface Mission ()
{

    int arrayEventIndex;
    int preStartCountdown;
    int elapsedDistanceInMeters;
    int missionID;
}
@end



@implementation Mission
-(id)initWithEventRoot:(EventNode*)rootNode
{
    if ( self = [super init] )
    {
        self.RootNode = rootNode;
    }
    return self;
}

-(void)missionStart
{
    preStartCountdown = 0;
    elapsedDistanceInMeters = 0;
    arrayEventIndex = 0;
    
}

-(void)missionTimerTick:(long)timeInHundredMs
{
    //check what event is scheduled to run, if it is a new event then raise a call to the missionController to display something....
    
}


//location changed
-(void)missionDistanceChanged:(float)distanceInMeters
{
    
}

@end

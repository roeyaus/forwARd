//
//  Event.m
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "Event.h"
#import "Task.h"
#import "Common.h"

@interface Event ()
{
    //triggers
   
    
}
@end

@implementation Event
-(id)initWithTriggers:(PlayMetrics*)triggers AndTask:(Task*)task 
{
    if ( self = [super init] )
    {
        self.triggerMetrics = triggers;
        self.eventTask = task;
    }
    return self;
}

-(bool)shouldRun:(PlayMetrics*)currentMetrics
{
    return [self.triggerMetrics isEqualOrSmallerThan:(PlayMetrics*)currentMetrics];
}

//location updated

@end

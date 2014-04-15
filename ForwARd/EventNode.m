//
//  EventNode.m
//  ForwARd
//
//  Created by Roey Lehman on 17/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "EventNode.h"

@implementation EventNode

-(id)initWithCurrentEvent:(Event*)event AndNextNode:(EventNode*)nextNode AndSuccessNode:(EventNode*)successNode AndFailNode:(EventNode*)failNode
{
    if (self = [super init])
    {
        self.CurrentEvent = event;
        self.NextNode = nextNode;
        self.SuccessNode = successNode;
        self.FailNode = failNode;
    }
    return self;
}
@end

//
//  EventNode.h
//  ForwARd
//
//  Created by Roey Lehman on 17/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventNode : NSObject

@property EventNode* NextNode;
@property EventNode* SuccessNode;
@property EventNode* FailNode;
@property Event* CurrentEvent;
-(id)initWithCurrentEvent:(Event*)event AndNextNode:(EventNode*)nextNode AndSuccessNode:(EventNode*)successNode AndFailNode:(EventNode*)failNode;
@end

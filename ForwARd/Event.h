//
//  Event.h
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task, EventTriggers, PlayMetrics;
//this is the Event Data the controller receives.


@interface Event : NSObject
@property long eventID;
@property NSString* eventName;
@property NSString* eventDisplayText;
@property NSString* soundFileName;
@property NSString* bgImageFileName;
@property NSString* fgImageFileName;
@property NSString* missionLogIconFileName;
@property NSString* eventTitle;
@property NSString* eventDescription;
@property Event* nextEvent; //link to the next event, if there's no task.
@property Event* nextEventIfTaskSuccess;
@property Event* nextEventIfTaskFail;
@property Event* previousEvent; //link to previous event, nil if root
@property Task* eventTask;
@property int numOfPointsAwarded;
@property PlayMetrics* triggerMetrics;
-(id)initWithTriggers:(PlayMetrics*)triggers AndTask:(Task*)task;
-(bool)shouldRun:(PlayMetrics*)currentMetrics;
@end



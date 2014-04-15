//
//  MissionFactory.m
//  ForwARd
//
//  Created by Roey Lehman on 26/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "MissionFactory.h"
#import "Mission.h"
#import "Event.h"
#import "Task.h"
#import "Common.h"
#import "EventNode.h"

@interface MissionFactory()
{
    
}
@end


@implementation MissionFactory


+(Mission*)getHardcodedMission
{
   
    
    //event
    
    
    //event L : secret code
    
    PlayMetrics* eventLMetrics = [[PlayMetrics alloc] initWithDistance:100 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    Event* eventL = [[Event alloc] initWithTriggers:eventLMetrics AndTask:nil];
    eventL.eventTitle = @"Secret Code Found! Remember it.";
    eventL.eventDescription = @"Secret Code Found! Remember it.";
    eventL.missionLogIconFileName = @"Graphics/symbol_blue.png";
    eventL.bgImageFileName = @"Graphics/blue.jpg";
    eventL.fgImageFileName = @"Graphics/weapon.png";
    
    //event I : guards chasing
    PlayMetrics* eventIMetrics = [[PlayMetrics alloc] initWithDistance:10 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    PlayMetrics* taskIMetrics = [[PlayMetrics alloc] initWithDistance:200 AndVelocity:20 AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    RunFasterThanTask* taskI = [[RunFasterThanTask alloc] initWithGoalMetrics:taskIMetrics AndNumberOfTimesAllowedUnderSpeed:10]; //this is about 5 seconds of running slower than the desired speed
    taskI.TaskTitle = @"Evade the guards! Stay over 10KPH for 200m!";
    taskI.successText = @"Congratulations! You've evaded the guards! 500pts";
    taskI.successPointsAwarded = 500;
    taskI.introSoundFileName = @"sounds/male voice/bobm ahead.wav";
    taskI.failText = @"Oh no, the guards got you!";
    taskI.failSoundFileName = @"sounds/male voice/hes_gotta get you.wav";
    Event* eventI = [[Event alloc] initWithTriggers:eventIMetrics AndTask:taskI ];
    eventI.eventTitle = @"Danger , Guards After You!";
    eventI.missionLogIconFileName = @"Graphics/symbol_red.png";
    eventI.bgImageFileName = @"Graphics/red.png";
   eventI.soundFileName = @"sounds/male voice/danger_guards.wav";
    //event H  : colleced shield level 1
    
    PlayMetrics* eventHMetrics = [[PlayMetrics alloc] initWithDistance:100 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    Event* eventH = [[Event alloc] initWithTriggers:eventHMetrics AndTask:nil];
    eventH.eventTitle = @"Collected Shield Level 1";
    eventH.eventDescription = @"Collected Shield Level 1";
    eventH.bgImageFileName = @"Graphics/orange.png";
    eventH.fgImageFileName = @"Graphics/shield.png";
    eventH.missionLogIconFileName = @"Graphics/symbol_orange.png";
    eventH.soundFileName = @"sounds/female voice/shield.wav";
    

    //event G supply capsule ahead
    PlayMetrics* eventGMetrics = [[PlayMetrics alloc] initWithDistance:50 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    Event* eventG = [[Event alloc] initWithTriggers:eventGMetrics AndTask:nil];
    eventG.eventTitle = @"Supply capsule";
    eventG.eventDescription = @"Supply capsule 100m ahead";
    eventG.bgImageFileName = @"Graphics/orange.png";
    eventG.fgImageFileName = @"Graphics/capsule.png";
    eventG.missionLogIconFileName = @"Graphics/symbol_orange.png";
     eventG.soundFileName = @"sounds/male voice/supply capsule ahead.wav";
    
    //event E : bomb 200m ahead
    PlayMetrics* eventEMetrics = [[PlayMetrics alloc] initWithDistance:100 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    PlayMetrics* taskEMetrics = [[PlayMetrics alloc] initWithDistance:200 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:1200 AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    DistanceInTimeTask* taskE = [[DistanceInTimeTask alloc] initWithGoalMetrics:taskEMetrics];
    taskE.TaskTitle = @"Reach the bomb in 2 minutes to disarm!";
    taskE.successText = @"Bomb disarmed!! congratulations!";
    taskE.introSoundFileName = @"sounds/male voice/bobm ahead.wav";
    taskE.FgImageFileName = @"Graphics/bomb.png";
    taskE.successSoundFileName = @"sounds/female voice/well_done.wav";
    taskE.countDownFrequencyInSecs = 20;
    taskE.successPointsAwarded = 500;
    
    Event* eventE = [[Event alloc] initWithTriggers:eventEMetrics AndTask:taskE];
    eventE.eventTitle = @"Bomb 200m Ahead";
    eventE.eventDescription = @"Reach the bomb to disarm it!!";
    eventE.bgImageFileName = @"Graphics/red.png";
    eventE.fgImageFileName = @"Graphics/bomb.png";
    eventE.missionLogIconFileName = @"Graphics/symbol_red.png";
    eventE.soundFileName = @"sounds/male voice/bobm ahead.wav";
       
    //EventD : Out of the zone
    PlayMetrics* eventDMetrics = [[PlayMetrics alloc] initWithDistance:200 AndVelocity:NON_INIT_NUMERICAL_VALUE AndTime:NON_INIT_NUMERICAL_VALUE AndLocation:nil AndNumOfPoints:NON_INIT_NUMERICAL_VALUE];
    Event* eventD = [[Event alloc] initWithTriggers:eventDMetrics AndTask:nil];
    eventD.eventTitle = @"Out Of The Zone!";
    eventD.eventDescription = @"Well Done! 200pts";
     eventD.missionLogIconFileName = @"Graphics/symbol_green.png";
    eventD.bgImageFileName = @"Graphics/green.jpg";
eventD.soundFileName = @"sounds/female voice/out_of_the_zone.wav";
    eventD.numOfPointsAwarded = 200;
    
    //Event C : Started moving, zone of exclusion

    PlayMetrics* eventCMetrics = [[PlayMetrics alloc] init];
    eventCMetrics.distanceInMeters = 10; //user started travelling
    Event* eventC = [[Event alloc] initWithTriggers:eventCMetrics AndTask:nil];
    eventC.eventTitle = @"Zone Of Exclusion";
    eventC.eventDescription = @"Run 200m to escape!";
    eventC.bgImageFileName = @"Graphics/red.png";
   eventC.missionLogIconFileName = @"Graphics/symbol_red.png";
    eventC.soundFileName = @"sounds/male voice/zone1.wav";
    
    
    //create event tree
    
    EventNode* eventNodeL = [[EventNode alloc] initWithCurrentEvent:eventL AndNextNode:nil AndSuccessNode:nil AndFailNode:nil];

     EventNode* eventNodeE2 = [[EventNode alloc] initWithCurrentEvent:eventE AndNextNode:nil AndSuccessNode:eventNodeL AndFailNode:eventNodeL];
    
     EventNode* eventNodeH2 = [[EventNode alloc] initWithCurrentEvent:eventH AndNextNode:eventNodeE2 AndSuccessNode:nil AndFailNode:nil];
    
    EventNode* eventNodeG2 = [[EventNode alloc] initWithCurrentEvent:eventG AndNextNode:eventNodeH2 AndSuccessNode:nil AndFailNode:nil];

    EventNode* eventNodeI = [[EventNode alloc] initWithCurrentEvent:eventI AndNextNode:nil AndSuccessNode:eventNodeG2 AndFailNode:eventNodeG2];
    
    EventNode* eventNodeH = [[EventNode alloc] initWithCurrentEvent:eventH AndNextNode:eventNodeI AndSuccessNode:nil AndFailNode:nil];
    
    EventNode* eventNodeG = [[EventNode alloc] initWithCurrentEvent:eventG AndNextNode:eventNodeH AndSuccessNode:nil AndFailNode:nil];
    
    EventNode* eventNodeE = [[EventNode alloc] initWithCurrentEvent:eventE AndNextNode:nil AndSuccessNode:eventNodeG AndFailNode:eventNodeG];

    EventNode* eventNodeD = [[EventNode alloc] initWithCurrentEvent:eventD AndNextNode:eventNodeE AndSuccessNode: nil AndFailNode:nil];
    
    EventNode* eventNodeC = [[EventNode alloc] initWithCurrentEvent:eventC AndNextNode:eventNodeD AndSuccessNode:nil AndFailNode:nil];

    
    Mission* m = [[Mission alloc] initWithEventRoot:eventNodeC];
    
    
    
    //create some global events
    
    m.globalEventList = [[NSMutableArray alloc] init];
    
    PlayMetrics* event1000mMetrics = [[PlayMetrics alloc] init];
    event1000mMetrics.distanceInMeters = 1000; //user started travelling
    Event* event1000m = [[Event alloc] initWithTriggers:event1000mMetrics AndTask:nil];
    event1000m.eventTitle = @"1K ";
    event1000m.eventDescription = @"Congratulations!";
    event1000m.bgImageFileName = @"Graphics/red.png";
    event1000m.missionLogIconFileName = @"Graphics/symbol_red.png";
    //event1000m.soundFileName = @"sounds/male voice/zone1.wav";
    
    [m.globalEventList addObject:event1000m];
    
    
    return m;
    
}

+(Mission*)getMissionWithID:(int)missionID
{
    
}



@end

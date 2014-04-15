//
//  MissionFactory.h
//  ForwARd
//
//  Created by Roey Lehman on 26/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>

//The missionfactory generates a mission object with all the required data for the mission.
//in the prototype everything will be hardcoded
@class Mission;

@interface MissionFactory : NSObject
+(Mission*)getHardcodedMission;
@end

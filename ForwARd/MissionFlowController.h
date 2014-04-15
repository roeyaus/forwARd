//
//  MissionFlowController.h
//  ForwARd
//
//  Created by Roey Lehman on 30/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CLLocationManagerDelegate.h"
@class CLLocationManager, EventUIData, TaskUIData, UIDisplayData, UITaskProgressData;

@protocol MissionFlowDelegate <NSObject>

-(void)didUpdateLocation:(int)distanceInMeters AndSpeed:(int)speedInKPH;
-(void)didTimerTick:(long)timeInHundredMs;
-(void)didStartNewEventWithDisplayData:(UIDisplayData*)displayData;
-(void)didStartNewTaskWithDisplayData : (UIDisplayData*)displayData
                     AndDistance:(float)distanceToTravelInMeters
                     AndTimeLeft:(float)timeLeftInMs;
-(void)didConcludeTaskWithDisplayData:(UIDisplayData*)displayData
                    AndSuccess:(bool)success
                   AndPoints:(long)  pointsAwarded;
-(void)didUpdateTaskProgress:(UITaskProgressData*)progressData;
@end

@interface MissionFlowController : NSObject <CLLocationManagerDelegate>
-(id)init;
- (void)startMission;
-(void)initMission;
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;
-(void)increaseDistanceBy20m;
@property bool shouldWaitForUI; //true means that an event is executing (sound/animation) in the UI and no events or tasks should start.
@property (nonatomic,assign) id<MissionFlowDelegate> delegate;
@property  NSMutableArray* eventHistory;
@end

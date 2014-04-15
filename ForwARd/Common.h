//
//  Common.h
//  ForwARd
//
//  Created by Roey Lehman on 26/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#ifndef ForwARd_Common_h
#define ForwARd_Common_h
@class CLLocation;
extern const int NON_INIT_NUMERICAL_VALUE;
extern const NSString* taskSuccessLogIconFilename;
extern const NSString* taskFailLogIconFilename;
const NSString* taskStartIconFilename ;

typedef enum TaskStatus_t
{
    NO_TASK_RUNNING = -1,
    TASK_RUNNING,
    TASK_SUCCESS,
    TASK_FAIL
} TaskStatus;

@interface PlayMetrics : NSObject
@property CLLocation* location;
@property int         distanceInMeters;
@property long        timeInHundredMs;
@property float       velocityInKPH;
@property long numOfPoints;
@property bool didTapScreen;

-(id)init;
-(id)initWithPlayMetrics:(PlayMetrics*)otherMetrics;
-(id)initWithDistance:(int)distanceInMeters AndVelocity:(int)velocityInKPH AndTime:(long)timeInHundredMs AndLocation:(CLLocation*)location AndNumOfPoints:(int)numOfPoints;
-(bool)isEqualOrSmallerThan:(PlayMetrics*)metricsToCompare;

-(void)resetMetricsToZero;
-(void)resetMetricsToUninitialized;
@end

@interface UIDisplayData : NSObject

@property long ID;
@property NSString* Title;
@property NSString* Description;
@property NSString* soundFileName;
@property NSString* bgImageFileName;
@property NSString* fgImageFileName;
@property NSString* missionLogIconFileName;
@property int numOfPoints;

@end

@interface UITaskProgressData : NSObject
@property int percentComplete;
@property int timeLeftInSeconds;
@property bool shouldReadCountdown;
@end
#endif

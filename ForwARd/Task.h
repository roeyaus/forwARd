//
//  Task.h
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@class PlayMetrics;
//this is the data that's linked with the task. it is also sent upwards to the controller
@interface Task : NSObject
@property long  taskID;
@property NSString* TaskTitle;
@property NSString* TaskDescription;
@property NSString* introSoundFileName;
@property int   countDownFrequencyInSecs;
//Success-Fail data
@property bool success;
@property NSString* successSoundFileName;
@property NSString* failSoundFileName;

@property NSString* successBgImageFileName;
@property NSString* FgImageFileName;
@property NSString* failBgImageFileName;

@property long  successPointsAwarded;
@property long  failPointsAwarded;
@property NSString* successText;
@property NSString* failText;
@property bool isRunning;

//metrics
@property PlayMetrics* startMetrics; //the start metrics are relative values, for example player has already run 2KM , in 12 minutes, and is running right now at 10KPH
@property PlayMetrics* goalMetrics; //the goal metrics are arbitrary values, for example player must run 100 m in 30 seconds or less, or must reach 15 KPH.
@property PlayMetrics* perfMetrics; //the perf metrics are arbitrary values indicating player performance in the task, for example player ran 200 meters,
//in 20 seconds and reached a top speed of 15 KPH

-(id)initWithGoalMetrics:(PlayMetrics*)goal;
-(bool)startTaskWithMetrics:(PlayMetrics*)metrics;
-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;
-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics*)currentMetrics;
@end



@interface DistanceInTimeTask: Task

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;

@end

@interface DistanceTask: Task

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;

@end

@interface RunFasterThanTask: Task
{
    int timesUnderSpeedCount;
}
-(id)initWithGoalMetrics:(PlayMetrics *)goal AndNumberOfTimesAllowedUnderSpeed:(int)numOfTimes;
-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;
@property int NumOfTimesUnderSpeed;
@end


@interface collectPointsTask : Task
{
   
}

 -(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;
-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics*)currentMetrics;
@end

@interface touchScreenTask : Task
{
    
}

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics;
-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics*)currentMetrics;
@end

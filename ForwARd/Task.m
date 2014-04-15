//
//  Task.m
//  ForwARd
//
//  Created by Roey Lehman on 23/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "Task.h"


@interface Task ()
{
  

}
@end

@implementation Task


-(id)initWithGoalMetrics:(PlayMetrics*)goal
{
    if ( self = [super init] ) {
        self.goalMetrics = goal;
        self.isRunning = false;
        self.successBgImageFileName = @"Graphics/green.jpg";
        self.failBgImageFileName = @"Graphics/red.png";
    }
    return self;
    
   
}

-(bool)validateTask
{
    //the task has some objective
    return (self.goalMetrics.distanceInMeters != NON_INIT_NUMERICAL_VALUE ||
            self.goalMetrics.timeInHundredMs != NON_INIT_NUMERICAL_VALUE ||
            self.goalMetrics.velocityInKPH != NON_INIT_NUMERICAL_VALUE ||
            self.goalMetrics.location != nil);
}

-(bool)startTaskWithMetrics:(PlayMetrics*)metrics
{
    self.startMetrics = [[PlayMetrics alloc] initWithPlayMetrics:metrics];
    
    if (![self validateTask])
    {
        return false;
    }
    self.isRunning = true;
    return true;
}

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics
{
    return TASK_FAIL;
}

-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics *)currentMetrics
{
    return nil;
}

@end

@implementation DistanceInTimeTask

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics
{
      if (currentMetrics.timeInHundredMs <= self.goalMetrics.timeInHundredMs)
      {
          if (currentMetrics.distanceInMeters >= self.goalMetrics.distanceInMeters)
          {
              self.isRunning = false;
              return TASK_SUCCESS;
          }
          else
          {
              return TASK_RUNNING;
          }
      }
      else
      {
          if (currentMetrics.distanceInMeters >= self.goalMetrics.distanceInMeters)
          {
               self.isRunning = false;
              return TASK_SUCCESS;
          }
          else
          {
               self.isRunning = false;
              return TASK_FAIL;
          }
      }
    

}

-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics *)currentMetrics
{
    UITaskProgressData* progress = [[UITaskProgressData alloc] init];
    progress.percentComplete = currentMetrics.distanceInMeters / self.goalMetrics.distanceInMeters * 100;
    progress.timeLeftInSeconds = (self.goalMetrics.timeInHundredMs - (currentMetrics.timeInHundredMs - self.startMetrics.timeInHundredMs)) / 10;
    if (self.countDownFrequencyInSecs > 0 && self.countDownFrequencyInSecs != NON_INIT_NUMERICAL_VALUE)
    {
        progress.shouldReadCountdown = progress.timeLeftInSeconds % self.countDownFrequencyInSecs == 0;
    }
    return progress;
}
@end


@implementation DistanceTask
-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics
{
    if (currentMetrics.distanceInMeters >= self.goalMetrics.distanceInMeters)
    {
        return TASK_SUCCESS;
    }
    return TASK_RUNNING;
}

-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics *)currentMetrics
{
    UITaskProgressData* progress = [[UITaskProgressData alloc] init];
    progress.percentComplete = currentMetrics.distanceInMeters / self.goalMetrics.distanceInMeters * 100;
    progress.timeLeftInSeconds = NON_INIT_NUMERICAL_VALUE;
    progress.shouldReadCountdown = false;
    return progress;
}
@end

@implementation RunFasterThanTask
-(id)initWithGoalMetrics:(PlayMetrics *)goal
{
    if (self = [super initWithGoalMetrics:goal])
    {
        
    }
    timesUnderSpeedCount = 10;
    self.NumOfTimesUnderSpeed = 10; //5 seconds under the goal speed are allowed
    return self;
}
-(id)initWithGoalMetrics:(PlayMetrics *)goal AndNumberOfTimesAllowedUnderSpeed:(int)numOfTimes
{
    if (self = [super initWithGoalMetrics:goal])
    {
        
    }
    timesUnderSpeedCount = numOfTimes;
    self.NumOfTimesUnderSpeed = numOfTimes;
    return self;
}

-(UITaskProgressData*)getProgressWithMetrics:(PlayMetrics *)currentMetrics
{
    UITaskProgressData* progress = [[UITaskProgressData alloc] init];
    progress.percentComplete = currentMetrics.distanceInMeters / self.goalMetrics.distanceInMeters * 100;
    progress.timeLeftInSeconds = (self.goalMetrics.timeInHundredMs - (currentMetrics.timeInHundredMs - self.startMetrics.timeInHundredMs)) * 10;
    if (self.countDownFrequencyInSecs > 0 && self.countDownFrequencyInSecs != NON_INIT_NUMERICAL_VALUE)
    {
        progress.shouldReadCountdown = progress.timeLeftInSeconds % self.countDownFrequencyInSecs == 0;
    }
    return progress;
}

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics*)currentMetrics
{
    if (currentMetrics.distanceInMeters >= self.goalMetrics.distanceInMeters)
    {
        if (timesUnderSpeedCount > 0)
        {
            timesUnderSpeedCount = self.NumOfTimesUnderSpeed;
            self.isRunning = false;
            return TASK_SUCCESS;
        }
        else
        {
            timesUnderSpeedCount = self.NumOfTimesUnderSpeed;
             self.isRunning = false;
            return TASK_FAIL;
        }
    }
    else
    {
        if (currentMetrics.velocityInKPH < self.goalMetrics.velocityInKPH)
        {
            if (--self.NumOfTimesUnderSpeed == 0)
            {
                timesUnderSpeedCount = self.NumOfTimesUnderSpeed;
                 self.isRunning = false;
                return TASK_FAIL;
            }
        }
        else
        {
            self.NumOfTimesUnderSpeed = timesUnderSpeedCount;
            return TASK_RUNNING;
        }
    }
    return  TASK_RUNNING;
}

@end

@implementation touchScreenTask

-(TaskStatus)didTaskFinishWithMetrics:(PlayMetrics *)currentMetrics
{
    if (currentMetrics.didTapScreen)
    {
        return TASK_SUCCESS;
    }
    return TASK_RUNNING;
}

@end
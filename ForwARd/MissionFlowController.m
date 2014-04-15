//
//  MissionFlowController.m
//  ForwARd
//
//  Created by Roey Lehman on 30/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "MissionFlowController.h"
#import "Mission.h"
#import "Event.h"
#import "EventNode.h"
#import "Task.h"
#import "MissionFactory.h"
#import "Foundation/NSTimer.h"
#import "CoreLocation/CLLocation.h"
#import "CoreLocation/CLLocationManager.h"
#import "Common.h"

@interface MissionFlowController ()
{
    Mission* mission;
    EventNode* currentNode;
    Event* currentEvent;
    //NSTimer* missionTimer;
    dispatch_source_t missionTimer;
    dispatch_queue_t missionTimerDispatchQueue;
    CLLocationManager* locationManager;
    int pointsCollected;
    PlayMetrics* totalMetrics; //these are the player metrics from the beginning of the mission
    PlayMetrics* currentMetrics; //these metrics are used to check if an event/task need to start, they are reset after each event/task completion
    Task* currentTask;
    
}

@end

@implementation MissionFlowController
-(id)initWithMission
{
    if (self == [super init])
    {
        
    }
    return self;
}

-(void)initMission
{
    mission = [MissionFactory getHardcodedMission];
    self.eventHistory = [[NSMutableArray alloc] init];
    currentNode = mission.RootNode;
    currentEvent = currentNode.CurrentEvent;
    self.shouldWaitForUI = false;
    //reset the play metrics
    totalMetrics = [[PlayMetrics alloc] init];
    [totalMetrics resetMetricsToZero];
    currentMetrics = [[PlayMetrics alloc]init];
    [currentMetrics resetMetricsToZero];

    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 1;
}

- (void)timerTick
{
    totalMetrics.timeInHundredMs += 1;
    currentMetrics.timeInHundredMs +=1;
    //update the onscreen timer
    [self.delegate didTimerTick:totalMetrics.timeInHundredMs];
    
    //We manage events every half second only, to avoid overloading the thread
    if ((totalMetrics.timeInHundredMs % 5 == 0))
    {
        [self manageEvents];
    }
    
}

-(void)increaseDistanceBy20m
{
    currentMetrics.distanceInMeters += 20;
    totalMetrics.distanceInMeters += 20;
    [self.delegate didUpdateLocation:totalMetrics.distanceInMeters AndSpeed:0];
    [self manageEvents];
}

-(void)manageEvents
{
    if (self.shouldWaitForUI) //UI is still playing sound/animation, we should wait for it - no sense in starting event while another one is still playing
    {
        NSLog(@"Waiting for UI...");
        return;
    }
    
    //check global events queue - if something needs to run then it takes precedence over all regular tasks/events
    
        //this should not run on the main timer thread, but may be premature optimization...
        if (currentTask != nil)
        {
            if (!currentTask.isRunning) //there's a task but it's not yet running
            {
                [currentMetrics resetMetricsToZero];
                [currentTask startTaskWithMetrics:currentMetrics]; //run the task
                //notify UI task is starting
                UIDisplayData* dd = [[UIDisplayData alloc] init];
                dd.Title = currentTask.TaskTitle;
                dd.Description = currentTask.TaskDescription ;
                dd.soundFileName = currentTask.introSoundFileName;
                [self.delegate didStartNewTaskWithDisplayData:dd AndDistance:currentTask.goalMetrics.distanceInMeters AndTimeLeft:currentTask.goalMetrics.timeInHundredMs];
                return;
            }
            else //there's a task and it's running
            {
                TaskStatus stat = [currentTask didTaskFinishWithMetrics:currentMetrics];
                currentMetrics.didTapScreen = false; //reset a tap, if there was one.
                if (stat == TASK_FAIL)
                {
                    UIDisplayData* dd = [[UIDisplayData alloc] init];
                    dd.Title = currentTask.TaskTitle;
                    dd.Description = currentTask.failText ;
                    dd.soundFileName = currentTask.failSoundFileName;
                    dd.fgImageFileName = currentTask.FgImageFileName;
                    dd.bgImageFileName = currentTask.failBgImageFileName;
                    
                    totalMetrics.numOfPoints += currentTask.failPointsAwarded;
                    dd.numOfPoints = totalMetrics.numOfPoints;
                   
                    [self.delegate didConcludeTaskWithDisplayData:dd AndSuccess:NO AndPoints:currentTask.failPointsAwarded];
                    [self updateCurrentEventWithEvent:currentNode.FailNode];
                    return;
                }
                else if (stat == TASK_SUCCESS)
                {
                    
                    UIDisplayData* dd = [[UIDisplayData alloc] init];
                    dd.Title = currentTask.TaskTitle;
                    dd.Description = currentTask.successText ;
                    dd.soundFileName = currentTask.successSoundFileName;
                    dd.fgImageFileName = currentTask.FgImageFileName;
                    dd.bgImageFileName = currentTask.successBgImageFileName;
                    
                    totalMetrics.numOfPoints += currentTask.successPointsAwarded;
                    dd.numOfPoints = totalMetrics.numOfPoints;
                    
                    [self.delegate didConcludeTaskWithDisplayData:dd AndSuccess:YES AndPoints:currentTask.successPointsAwarded];
                    [self updateCurrentEventWithEvent:currentNode.SuccessNode];
                    return;
                }
                else
                {
                    //task still running...maybe need to update UI on task progress?
                    [self.delegate didUpdateTaskProgress:[currentTask getProgressWithMetrics:currentMetrics]];
                    
                }
            }
        }
    
    else //there's an event queued, so check if it needs to run
    {
        if ([currentEvent shouldRun:currentMetrics])
        {
            //event should run, notify the UI
            [self.eventHistory addObject:currentEvent];
            UIDisplayData* dd = [[UIDisplayData alloc] init];
            dd.Title = currentEvent.eventTitle;
            dd.Description = currentEvent.eventDescription ;
            dd.soundFileName = currentEvent.soundFileName;
            dd.bgImageFileName = currentEvent.bgImageFileName;
            dd.fgImageFileName = currentEvent.fgImageFileName;
            dd.missionLogIconFileName = currentEvent.missionLogIconFileName;
            
            totalMetrics.numOfPoints += currentEvent.numOfPointsAwarded;
            
            dd.numOfPoints = totalMetrics.numOfPoints;
            
            if (currentEvent.eventTask != nil) //event has task, we should run it.
            {
                currentTask = currentEvent.eventTask;
                dd.Description = currentTask.TaskTitle; //the event description is the task title.
                [self.delegate didStartNewEventWithDisplayData:dd]; //raise event to UI
            }
            else //no task, move along...
            {
                [self.delegate didStartNewEventWithDisplayData:dd]; //raise event to UI
                //move to next event
                [self updateCurrentEventWithEvent:currentNode.NextNode];
            }
        }
        // else: event shouldn't run yet, do nothing
    }
    
}

-(void)updateCurrentEventWithEvent:(EventNode*)node
{
    currentNode = node;
    currentEvent = currentNode.CurrentEvent;
    currentTask = nil;
    //reset metrics
    [currentMetrics resetMetricsToZero];
    
}

- (void)startMission
{
    
    [locationManager startUpdatingLocation];
    //start mission timer;
    //missionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    missionTimerDispatchQueue = dispatch_queue_create("missionTimerDispatchQueue", NULL);
    missionTimer = dispatch_source_create(
                                                     DISPATCH_SOURCE_TYPE_TIMER, 0, 0, missionTimerDispatchQueue);
    dispatch_source_set_timer(missionTimer, dispatch_time(DISPATCH_TIME_NOW
                                                   , NSEC_PER_MSEC * 100), NSEC_PER_MSEC * 100, 0);
    
    // Hey, let's actually do something when the timer fires!
    dispatch_source_set_event_handler(missionTimer, ^{
        [self timerTick];
        NSLog(@"timer tick");
    });
    
    // now that our timer is all set to go, start it
    dispatch_resume(missionTimer);
    
}




- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //need to check current location and each one meter change, check if user has moved enough to warrant starting the next event.
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 2.0)
    {
        
        currentMetrics.distanceInMeters += [location distanceFromLocation:currentMetrics.location];
        totalMetrics.distanceInMeters += [location distanceFromLocation:currentMetrics.location];
        currentMetrics.location = location;
        currentMetrics.velocityInKPH = location.speed * 3.6;
        [self.delegate didUpdateLocation:totalMetrics.distanceInMeters AndSpeed:currentMetrics.velocityInKPH];
        [self manageEvents];
        
    }
}

-(void)didTapScreen
{
    currentMetrics.didTapScreen = true;
}
@end

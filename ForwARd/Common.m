#import "Common.h"

const int NON_INIT_NUMERICAL_VALUE = -1;
const NSString* taskSuccessLogIconFilename = @"Graphics/symbol_green.png";
const NSString* taskFailLogIconFilename = @"Graphics/symbol_red.png";
const NSString* taskStartIconFilename = @"Graphics/symbol_red.png";
@implementation PlayMetrics

-(id)init
{
    if ([super init])
    {
        [self resetMetricsToUninitialized];
    }
    return self;
}

-(id)initWithDistance:(int)distanceInMeters AndVelocity:(int)velocityInKPH AndTime:(long)timeInHundredMs AndLocation:(CLLocation*)location AndNumOfPoints:(int)numOfPoints
{
    if ([super init])
    {
        self.distanceInMeters = distanceInMeters;
        self.velocityInKPH = velocityInKPH;
        self.timeInHundredMs = timeInHundredMs;
        self.location = location;
        self.numOfPoints = numOfPoints;
    }
    return self;
}

-(id)initWithPlayMetrics:(PlayMetrics*)otherMetrics
{
    if ([super init])
    {
        self.distanceInMeters = otherMetrics.distanceInMeters;
        self.velocityInKPH = otherMetrics.velocityInKPH;
        self.timeInHundredMs = otherMetrics.timeInHundredMs;
        self.location = otherMetrics.location;
        self.numOfPoints = otherMetrics.numOfPoints;
    }
    return self;
}

-(bool)isEqualOrSmallerThan:(PlayMetrics*)metricsToCompare
{
    //compare metrics with triggers, if ALL defined trigger metrics are satisfied then the event should run
    if ((metricsToCompare.timeInHundredMs != NON_INIT_NUMERICAL_VALUE  &&  self.timeInHundredMs != NON_INIT_NUMERICAL_VALUE && self.timeInHundredMs <= metricsToCompare.timeInHundredMs) ||
    (metricsToCompare.distanceInMeters != NON_INIT_NUMERICAL_VALUE  &&  self.distanceInMeters != NON_INIT_NUMERICAL_VALUE && self.distanceInMeters <= metricsToCompare.distanceInMeters) ||
    (metricsToCompare.velocityInKPH != NON_INIT_NUMERICAL_VALUE  &&  self.velocityInKPH != NON_INIT_NUMERICAL_VALUE && self.velocityInKPH <= metricsToCompare.velocityInKPH)
    )
    {
        //one or more of the metric conditions was met
        return true;
    }
    return false;
}




-(void)resetMetricsToZero
{
    self.distanceInMeters = 0;
    self.velocityInKPH = 0;
    self.timeInHundredMs = 0;
    self.location = nil; //current location
    self.numOfPoints = 0;
}

-(void)resetMetricsToUninitialized
{
    self.distanceInMeters = NON_INIT_NUMERICAL_VALUE;
    self.velocityInKPH = NON_INIT_NUMERICAL_VALUE;
    self.timeInHundredMs = NON_INIT_NUMERICAL_VALUE;
    self.location = nil;
    self.numOfPoints = NON_INIT_NUMERICAL_VALUE;

}
@end


@implementation UIDisplayData

@end

@implementation UITaskProgressData


@end



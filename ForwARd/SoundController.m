//
//  SoundController.m
//  ForwARd
//
//  Created by Roey Lehman on 25/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "SoundController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

NSString* extension = @"wav";

@implementation SoundController

+(void)internalAddNumberToAVPlayerItemSequence:(int)number WithAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence
{
    if (number > 0)
    {
        if (number < 20)
        {
            [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/%d", number] ofType:extension]]]];
        }
        else if (number >=20)
        {
            int digit = number % 10;
            int tens = (number / 10) * 10;
            int hundreds = (number / 100);
            if (hundreds > 0 && hundreds < 10)
            {
                [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/%d", hundreds] ofType:extension]]]];
                [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/100"] ofType:extension]]]];
            }
            if (tens > 0)
                [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/%d", tens] ofType:extension]]]];
            if (digit > 0)
            {
                [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/%d", digit] ofType:extension]]]];
            }
        }
    }
    
}

+(void)addNumberToAVPlayerItemSequence:(int)number withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence
{
    int thousands = number / 1000;
    [self internalAddNumberToAVPlayerItemSequence:thousands WithAVPlayerItemSequence:AVPlayerItemSequence];
    int restOfNum = number % 1000;
    [self internalAddNumberToAVPlayerItemSequence:restOfNum WithAVPlayerItemSequence:AVPlayerItemSequence];
}

+(void)addNumberOfPointsToAVPlayerItemSequence:(int)numOfPoints withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence
{
    NSString* extension = @"wav";
    [self addNumberToAVPlayerItemSequence:numOfPoints withAVPlayerItemSequence:AVPlayerItemSequence];
    [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/EPoints"] ofType:extension]]]];
    
}

+(void)addTimeToAVPlayerItemSequence:(int)timeInSeconds withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence
{
    int hours = timeInSeconds / 3600;
    int minutes = timeInSeconds / 60;
    int seconds = timeInSeconds % 60;
    NSString* extension = @"wav";
    if (hours >0)
    {
        [self addNumberToAVPlayerItemSequence:hours withAVPlayerItemSequence:AVPlayerItemSequence];
        [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/minutes"] ofType:extension]]]];
    }
    if (minutes > 0)
    {
        [self addNumberToAVPlayerItemSequence:minutes withAVPlayerItemSequence:AVPlayerItemSequence];
        [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/minutes"] ofType:extension]]]];
    }
    if (seconds > 0)
    {
        [self addNumberToAVPlayerItemSequence:seconds withAVPlayerItemSequence:AVPlayerItemSequence];
        [AVPlayerItemSequence addObject:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sounds/male voice/seconds"] ofType:extension]]]];
    }

}

+(void)addTaskTimeLimitToAVPlayerItemSequence:(int)timeLimitInSeconds withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence
{
    //need to add : "You have X minutes" , or maybe "In X minutes Y seconds". don't have those sound files yet.
    //so now does nothing
}




@end

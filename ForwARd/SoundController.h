//
//  SoundController.h
//  ForwARd
//
//  Created by Roey Lehman on 25/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>

//The sound controller is the API to play any sound in forwARd. Sounds are played on a seperate thread (uses AVAudioPlayer)
//Users of this interface must register as a delegate in order to be told when playback has finished (or failed).

@interface SoundController : NSObject

+(void)addNumberToAVPlayerItemSequence:(int)number withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence;
+(void)addNumberOfPointsToAVPlayerItemSequence:(int)numOfPoints withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence;
+(void)addTimeToAVPlayerItemSequence:(int)timeInSeconds withAVPlayerItemSequence:(NSMutableArray*)AVPlayerItemSequence;
@end

//
//  MissionViewController.h
//  ForwARd
//
//  Created by Roey Lehman on 26/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MissionFlowController.h"


@interface MissionViewController : UIViewController <MissionFlowDelegate, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskName;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceRun;
@property (weak, nonatomic) IBOutlet UITableView *tvEventList;

@property (weak, nonatomic) IBOutlet UIImageView *ivHour1;
@property (weak, nonatomic) IBOutlet UIImageView *ivHour2;
@property (weak, nonatomic) IBOutlet UIImageView *ivMinute1;
@property (weak, nonatomic) IBOutlet UIImageView *ivMinute2;
@property (weak, nonatomic) IBOutlet UIImageView *ivSecond1;
@property (weak, nonatomic) IBOutlet UIImageView *ivSecond2;
@property (weak, nonatomic) IBOutlet UIImageView *ivHundredth;
@property (weak, nonatomic) IBOutlet UISwitch *swSounds;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblEnergyPoints;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnMove20;
-(void)didUpdateLocation:(int)distanceInMeters;
-(void)didTimerTick:(long)timeInHundredMs;
- (IBAction)btnStartTouched:(id)sender;
- (IBAction)btnMove20Touched:(id)sender;
@end

//
//  MissionViewController.m
//  ForwARd
//
//  Created by Roey Lehman on 26/04/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import "MissionViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "dispatch/dispatch.h"
#import "Event.h"
#import "Common.h"
#import "AlertModalViewController.h"
#import "SoundController.h"

@interface MissionViewController ()
{
    MissionFlowController* missionFlowController;
    NSTimer* missionTimer;
    int elapsedTimeInHundredMS;
    NSMutableArray* displayDataArray;
    AVAudioPlayer* player;
    AVQueuePlayer *Qplayer;
    dispatch_queue_t soundDispatchQueue;
    AlertModalViewController* alertModalVC;
    bool running;
    
    

}
@end

@implementation MissionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    elapsedTimeInHundredMS = 0;
    /* Use this code to play an audio file */
    soundDispatchQueue = dispatch_queue_create("sounddispatchqueue", NULL);
    running = false;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    alertModalVC = (AlertModalViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"AlertModalViewController"];
    displayDataArray = [[NSMutableArray alloc] init];
 
    missionFlowController = [[MissionFlowController alloc] init];
    missionFlowController.delegate = self;
    [missionFlowController initMission];
   
    //start the mission timer thread.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

  //locks the UI for new events/updates
-(void)pauseMissionFlowController
{
    missionFlowController.shouldWaitForUI = true;
}

 //locks the UI for new events/updates
-(void)resumeMissionFlowController
{
    missionFlowController.shouldWaitForUI = false;
}

-(NSString*)GetTimerStringFromTime:(long)timeInHundredMs
{
    int seconds = (timeInHundredMs / 10) % 60;
    int minutes = (timeInHundredMs / 10 / 60) % 60;
    int hours = (timeInHundredMs / 10 / 3600);
    int ms = timeInHundredMs % 10;
    return [NSString stringWithFormat:@"%02d:%02d:%02d.%d", hours, minutes, seconds, ms];
}

//--------------------------------------- Sound related selectors -------------------------------------------------

-(void)playSoundOnDispatchQueueWithFileName:(NSString*)soundFileName
{
     dispatch_async(soundDispatchQueue, ^{
         NSString* fileName = [soundFileName stringByDeletingPathExtension];
         NSString* extension = [soundFileName pathExtension];
         NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
         player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
         player.numberOfLoops = 0; //Infinite
         player.delegate = self;
         [player play];

     });
}

-(void)playAudioCountdownOnQueue:(int)timeLeftInSeconds
{
   
    
    dispatch_async(soundDispatchQueue, ^{
        
        NSMutableArray* piArray = [[NSMutableArray alloc] init];
        
        [SoundController addTimeToAVPlayerItemSequence:timeLeftInSeconds withAVPlayerItemSequence:piArray];
                    
        Qplayer = [[AVQueuePlayer alloc] initWithItems:piArray];
        
        [Qplayer play];
    });
    
}

-(void)playAVPlayerItemSequence:(NSMutableArray*)aVPlayerItemSequence withCallback:(SEL)selector
{
    
    // get a pointer to the last item in the array
    AVPlayerItem* playerItem = [aVPlayerItemSequence objectAtIndex:aVPlayerItemSequence.count - 1];
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selector) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
  
    [self pauseMissionFlowController];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Qplayer = [[AVQueuePlayer alloc] initWithItems:aVPlayerItemSequence];
        [Qplayer play];
    });
    
}

-(void)itemDidFinishPlaying {
    // Will be called when AVPlayer finishes playing playerItem
    [self resumeMissionFlowController];
}


//THIS SIMULATES THE PLAYING OF SOUND EFFECTS, TO KEEP THE ALERT SCREEN OPEN
- (void)timerTick:(NSTimer*)theTimer
{
    [self resumeMissionFlowController];
    [alertModalVC dismissViewControllerAnimated:YES completion:NULL];
}



-(void)performUIUpdates:(UIDisplayData*)displayData
{
    [displayDataArray insertObject:displayData atIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self pauseMissionFlowController];
           
        if (displayData.soundFileName == nil || ![self.swSounds isOn])
        {
            [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:NO];
        }
        else
        {
            [self playSoundOnDispatchQueueWithFileName:displayData.soundFileName];
        }
        

        [alertModalVC dismissViewControllerAnimated:FALSE completion:NULL];
        
        
        alertModalVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:alertModalVC animated:YES completion:NULL];
        [alertModalVC.ivBackGround setImage:[UIImage imageNamed:displayData.bgImageFileName]];
        [alertModalVC.ivForeGround setImage:[UIImage imageNamed:displayData.fgImageFileName]];
        alertModalVC.lblTitle.text = displayData.Title;
        alertModalVC.lblDescription.text = displayData.Description;
        
        self.lblEnergyPoints.text = [NSString stringWithFormat:@"%d", displayData.numOfPoints];
        
        [self.tvEventList beginUpdates];
        NSArray* arr = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0/*(displayDataArray.count - 1)*/ inSection:0], nil];
        [self.tvEventList insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        [self.tvEventList endUpdates];
    });
}

- (IBAction)btnStartTouched:(id)sender
{
    if (!running)
    {
        running = true;
        [missionFlowController startMission];
    }
    
}

- (IBAction)btnMove20Touched:(id)sender
{
    [missionFlowController increaseDistanceBy20m];
}

-(void)StartAudioCountdown:(int)countdownInterval
{
    
}


//-------------------------------    MissionFlowDelegate selectors   ------------------------------------------------

//these selectors are run on a SEPERATE thread (timer thread or location thread) and so any UI change MUST be queued to the UI thread.
//the timer/location keeps sending events but since all are queued to the UI thread then no sync need be done.
//HOWEVER sound files and animations, must be run on a seperate thread,
//and so ANY event EXCEPT didTimerTick and didUpdateLocation MUST wait till they finish before queuing something new to the UI.
//this might be accomplished by setting a flag in the flow controller, to stop processing events until the last one finishes playing

-(void)didTimerTick:(long)timeInHundredMs
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int seconds = (timeInHundredMs / 10) % 60;
        int minutes = (timeInHundredMs / 10 / 60) % 60;
        int hours = (timeInHundredMs / 10 / 3600);
        int ms = timeInHundredMs % 10;
        
        [self.ivHour1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", hours / 10]]];
        [self.ivHour2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", hours % 10]]];
        [self.ivMinute1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", minutes / 10]]];
        [self.ivMinute2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", minutes % 10]]];
        [self.ivSecond1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", seconds / 10]]];
        [self.ivSecond2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", seconds % 10]]];
        [self.ivHundredth setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Graphics/Digits/%d.png", ms]]];
        //self.lblTimer.text = [self GetTimerStringFromTime:timeInHundredMs];

    });
   }



-(void)didUpdateLocation:(int)distanceInMeters AndSpeed:(int)speedInKPH
{
    //might need to pass some more parameters
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblDistanceRun.text = [NSString stringWithFormat:@"%dm", distanceInMeters >= 0 ? distanceInMeters : 0];
        self.lblSpeed.text = [NSString stringWithFormat:@"%d KPH", speedInKPH >= 0 ? speedInKPH : 0];
        
    });
}


-(void)didConcludeTaskWithDisplayData:(UIDisplayData*)displayData
                           AndSuccess:(bool)success
                            AndPoints:(long)  pointsAwarded
{
    NSLog(@"Task %@", success ? @"success!" : @"failed");
    displayData.missionLogIconFileName = success ? taskSuccessLogIconFilename : taskFailLogIconFilename;
    [self performUIUpdates:displayData];

    
}

-(void)didStartNewEventWithDisplayData:(UIDisplayData*)displayData
{
    NSLog(@"Event : %@", displayData.Title);
    
     [self performUIUpdates:displayData];

   

}

-(void)didStartNewTaskWithDisplayData : (UIDisplayData*)displayData
                           AndDistance:(float)distanceToTravelInMeters
                           AndTimeLeft:(float)timeLeftInMs
{
      NSLog(@"Task : %@", displayData.Title);
    displayData.missionLogIconFileName = taskStartIconFilename;
      //[displayDataArray addObject:displayData];
}

-(void)didUpdateTaskProgress:(UITaskProgressData *)progressData
{
    if (progressData.shouldReadCountdown)
    {
        [self playAudioCountdownOnQueue:progressData.timeLeftInSeconds];
    }
}

//--------------------------------------------------- AVAudioPlayerDelegate -----------------------------------------------

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [alertModalVC dismissViewControllerAnimated:YES completion:NULL];
    [self resumeMissionFlowController];
}

//--------------------------------------------------- UITableView delegates -----------------------------------------------

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    NSLog(@"missionflowcontroller.eventhistory.count at numberOfRowsInSecion : %d", displayDataArray.count);
    return displayDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell... setting the text of our cell's label
    UIDisplayData* dd = [displayDataArray objectAtIndex:indexPath.row];
    UILabel* lbl = (UILabel*)[cell.contentView viewWithTag:1];
    lbl.text = dd.Title;
    lbl = (UILabel*)[cell.contentView viewWithTag:3];
    lbl.text = dd.Description;
    UIImageView* iv = (UIImageView*)[cell.contentView viewWithTag:2];
    UIImage* res = [UIImage imageNamed:dd.missionLogIconFileName];
    [iv setImage: res];
   
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end

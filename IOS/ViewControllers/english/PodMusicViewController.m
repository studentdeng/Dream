//
//  PodMusicViewController.m
//  Listener
//
//  Created by yg curer on 13-1-22.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "PodMusicViewController.h"

@interface PodMusicViewController ()

@property (nonatomic, retain) MPMusicPlayerController *libMusicPlayer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSNumber *identify;
@property (nonatomic, assign) double endTimeInSec;

@end

@implementation PodMusicViewController
@synthesize currentTimeLabel;
@synthesize endTimeLabel;
@synthesize timeSlider;
@synthesize playButton;
@synthesize backButton;
@synthesize backFarButton;
@synthesize LRCTextView;

- (void)dealloc {
    [self.libMusicPlayer pause];
    
    NSNumber *progressLatest = [NSNumber numberWithDouble:self.libMusicPlayer.currentPlaybackTime];
    [[NSUserDefaults standardUserDefaults] setObject:progressLatest
                                              forKey:[self.identify stringValue]];
    [[NSUserDefaults standardUserDefaults] setObject:self.identify
                                              forKey:MUSIC_PROGRESS_RECENTLY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.libMusicPlayer = nil;
    self.identify = nil;
    self.mediaItemCollection = nil;
    self.timer = nil;
}

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
    // Do any additional setup after loading the view from its nib.
    self.libMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    [self.libMusicPlayer setQueueWithItemCollection:self.mediaItemCollection];
    
    [self.playButton addTarget:self
                        action:@selector(playButtonDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self
                        action:@selector(playBackDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.backFarButton addTarget:self
                           action:@selector(playBackDidClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    MPMediaItem *song = [self.mediaItemCollection representativeItem];
    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString *lrc = [song valueForProperty:MPMediaItemPropertyLyrics];
    NSNumber *endTime_s = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.endTimeInSec = [endTime_s doubleValue];
    self.endTimeLabel.text = [self formatTime:[endTime_s intValue]];
    self.currentTimeLabel.text = @"0:00";
    
    self.title = title;
    
    self.LRCTextView.text = lrc;
    
    self.identify = [song valueForProperty:MPMediaItemPropertyPersistentID];
    NSNumber *progressLatest =
        [[NSUserDefaults standardUserDefaults] objectForKey:[self.identify stringValue]];
    if (progressLatest != nil)
    {
        self.libMusicPlayer.currentPlaybackTime = [progressLatest doubleValue];
    }
    
    [self play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [self setBackButton:nil];
    [self setBackFarButton:nil];
    [self setLRCTextView:nil];
    
    [self setCurrentTimeLabel:nil];
    [self setEndTimeLabel:nil];
    [self setTimeSlider:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - action

- (void)playButtonDidClicked:(UIButton *)button
{
    if ([self.libMusicPlayer playbackState] != MPMoviePlaybackStatePlaying) {
        [self play];
    }
    else
    {
        [self pause];
    }
}

- (void)play
{
    [self.libMusicPlayer play];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(updateMeters)
                                                userInfo:nil
                                                 repeats:YES];
    self.timeSlider.enabled = YES;
}

- (void)pause
{
    [self.libMusicPlayer pause];
    self.timeSlider.enabled = NO;
}

- (void)playBackDidClicked:(UIButton *)button
{
    if (button == self.backButton) {
        if (self.libMusicPlayer.currentPlaybackTime > 5) {
            self.libMusicPlayer.currentPlaybackTime -= 5;
        }
        else
        {
            self.libMusicPlayer.currentPlaybackTime = 0;
        }
    }
    else if (button == self.backFarButton)
    {
        if (self.libMusicPlayer.currentPlaybackTime > 10) {
            self.libMusicPlayer.currentPlaybackTime -= 10;
        }
        else
        {
            self.libMusicPlayer.currentPlaybackTime = 0;
        }
    }
    
    [self play];
}

#pragma mark - timer

- (void)updateMeters
{
    if (self.libMusicPlayer == nil)
        return;

    self.timeSlider.value = self.libMusicPlayer.currentPlaybackTime / self.endTimeInSec;
    
    self.currentTimeLabel.text = [self formatTime:self.libMusicPlayer.currentPlaybackTime];
}

- (IBAction)scrubbbingDone: (id) sender
{
    [self play];
}

- (IBAction)scrub: (id) sender
{
    // Pause the player
    [self.libMusicPlayer pause];
    [self.timer invalidate];
    
    // Calculate the new current time
    self.libMusicPlayer.currentPlaybackTime = self.timeSlider.value * self.endTimeInSec;
}

- (NSString *)formatTime: (int) num
{
    int secs = num % 60;
    int min = num / 60;
    
    if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
    
    return [NSString stringWithFormat:@"%d:%02d", min, secs];
}

@end

//
//  PodMusicViewController.h
//  Listener
//
//  Created by yg curer on 13-1-22.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PodMusicViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backFarButton;
@property (weak, nonatomic) IBOutlet UITextView *LRCTextView;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;

@property (retain, nonatomic) MPMediaItemCollection *mediaItemCollection;

- (IBAction)scrubbbingDone: (id) sender;
- (IBAction)scrub: (id) sender;

@end

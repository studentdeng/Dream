//
//  EnglishViewController.h
//  Dream
//
//  Created by yg curer on 13-3-30.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface EnglishViewController : UIViewController <MPMediaPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)recentlyClicked:(id)sender;
- (IBAction)captureClicked:(id)sender;

@end

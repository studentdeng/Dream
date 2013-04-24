//
//  EnglishViewController.m
//  Dream
//
//  Created by yg curer on 13-3-30.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "EnglishViewController.h"
#import "PodMusicViewController.h"
#import "ECSlidingViewController.h"
#import "PictureManager.h"

#import "WBNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "TimeFormatter.h"
#import "BlockAlertView.h"

#define ENGLISH_PROGRESS_ID @"1"

@interface EnglishViewController ()

@property (nonatomic, retain) MPMediaItemCollection *recentlyItem;
@property (nonatomic, retain) NSDate *beginDate;

@property (nonatomic, strong) ASIHTTPRequest *request;

@end

@implementation EnglishViewController

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
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *tagListVC = [[MenuViewController alloc] init];
        self.slidingViewController.underLeftViewController  = tagListVC;
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(importMusicClicked)];
    
    NSNumber *identify = [[NSUserDefaults standardUserDefaults] objectForKey:MUSIC_PROGRESS_RECENTLY];
    if (identify != nil) {
        [self showRecentlyInfo:identify];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@?plan_id=1", [API apiPath:EVALUATE_PLAN]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:string]];
    
    [request startSynchronous];
    
    NSDictionary *dic = [[request responseString] JSONValue];
    NSString *html = [dic objectForKey:@"html"];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)showRecentlyInfo:(NSNumber *)identifyNumber
{
    MPMediaPropertyPredicate *predicate =
        [MPMediaPropertyPredicate predicateWithValue:identifyNumber
                                         forProperty:MPMediaItemPropertyPersistentID];
    
    MPMediaQuery *mySongQuery = [[MPMediaQuery alloc] init];
    [mySongQuery addFilterPredicate: predicate];
    
    NSArray *albums = [mySongQuery collections];
    MPMediaItemCollection *album = [albums lastObject];
    
    self.recentlyItem = album;
    
    MPMediaItem *song = [album representativeItem];
    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
    
    self.songNameLabel.text = title;
}

- (void)importMusicClicked
{
    MPMediaPickerController *mpController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mpController.delegate = self;
    mpController.prompt = @"Add songs to play";
    mpController.allowsPickingMultipleItems = NO;
    
    [self presentModalViewController:mpController animated:YES];
}

#pragma mark Media item picker delegate methods________

// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	// Dismiss the media item picker.
	[self dismissModalViewControllerAnimated: YES];
	
	// Apply the chosen songs to the music player's queue.
	[self updatePlayerQueueWithMediaCollection: mediaItemCollection];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}

- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection
{
    
    PodMusicViewController *podMusicVC = [[PodMusicViewController alloc] init];
    podMusicVC.mediaItemCollection = mediaItemCollection;
    
    [self.navigationController pushViewController:podMusicVC animated:YES];
}

- (void)viewDidUnload {
    [self setSongNameLabel:nil];
    [self setWebView:nil];
    [self setPlayButton:nil];
    [self setCaptureButton:nil];
    [self setProgressBeginTimeLabel:nil];
    [super viewDidUnload];
}

#pragma mark - action

- (IBAction)recentlyClicked:(id)sender {
    [self updatePlayerQueueWithMediaCollection:self.recentlyItem];
}

- (IBAction)captureClicked:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) {
        
        //don't have camera
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"alert"
                                                            message:@"don't have any camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)playButtonClicked:(id)sender {
    
    self.beginDate = [NSDate date];
    self.progressBeginTimeLabel.text = [NSString stringWithFormat:@"start at %@", [TimeFormatter formatTime:self.beginDate]];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* thumbImage = [PictureManager scaleAndRotateImage:image andMaxLen:200];
    
    //UIImageWriteToSavedPhotosAlbum(thumbImage, nil, nil,nil);
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, 1);
    [self requestToServerUpload:imageData];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
}

#pragma mark - server

- (void)requestToServerUpload:(NSData *)imageData
{
    [[API shareObjectManager] post:UPLOAD_FILE
                         userBlock:^(ASIFormDataRequest *ASIRequest) {
                             [ASIRequest setData:imageData
                                    withFileName:@"test.jpg"
                                  andContentType:@"image/jpeg"
                                          forKey:@"image"];
                         } success:^(ASIHTTPRequest *ASIRequest, NSDictionary *object) {
                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"Photo Saved Successfully"];
                             [notice show];
                             
                             BlockAlertView *alert = [BlockAlertView alertWithTitle:@"info"
                                                                            message:@"do u want to finished progress now?"];
                             [alert setCancelButtonWithTitle:@"not yet"
                                                       block:^{
                                                       }];
                             [alert addButtonWithTitle:@"sure"
                                                 block:^{
                                                     [self requestToServerEndProgress];
                                                 }];
                             [alert show];
                             
                         } error:^(ASIHTTPRequest *ASIRequest, NSString *errorMsg) {
                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"Photo Saved Error"];
                             [notice show];
                         }];
}

- (void)requestToServerEndProgress
{
    NSDate *finishedDate = [NSDate date];
    
    double timeInSec = [TimeFormatter timeDiffInSec:self.beginDate andEnd:finishedDate];
    double timeInMin = round(timeInSec / 60.0f);
    
    [[API shareObjectManager] post:ADD_PROGRESS
                         userBlock:^(ASIFormDataRequest *ASIRequest) {
                             [ASIRequest addPostValue:[NSNumber numberWithDouble:timeInMin] forKey:@"cost_time_min"];
                             [ASIRequest addPostValue:ENGLISH_PROGRESS_ID forKey:@"plan_id"];
                         } success:^(ASIHTTPRequest *ASIRequest, NSDictionary *object) {
                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"request Successfully"];
                             [notice show];
                             
                             self.beginDate = nil;
                             self.progressBeginTimeLabel.text = @"";
                             
                         } error:^(ASIHTTPRequest *ASIRequest, NSString *errorMsg) {
                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"add progress Error"];
                             [notice show];
                         }];
}

@end

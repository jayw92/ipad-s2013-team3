//
//  ViewController.h
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson.
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    AVQueuePlayer *queueplayer;
    bool musicPlaying;
    int currTrack;
    CGFloat locX;
    CGFloat locY;
    int numOfNotes;
    int pngNum;
    CGFloat spaceBetweenX;
    CGFloat spaceBetweenY;
    CGFloat startingStaffY;
    CGFloat allowError;
    CGFloat screenWidth;
    CGContextRef context;
    NSMutableArray *noteLocations;
    NSMutableArray *soundURLs;
    NSMutableArray *soundNumbers;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer2;

-(BOOL) isOnStaff:(CGPoint)pos;
-(BOOL) isBetweenStaff:(CGPoint)pos;

-(void) handle2Taps:(UITapGestureRecognizer *)sender;
-(void) handleTaps:(UITapGestureRecognizer *)sender;

-(void) findNotePosition:(int)noteType;

-(void) deleteNoteAt:(CGPoint)pos;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (retain, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UIButton *StopButton;
@property (retain, nonatomic) IBOutlet UIButton *SaveButton;
@property (retain, nonatomic) IBOutlet UIButton *OpenButton;
@property (weak, nonatomic) IBOutlet UIButton *SettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *NoteTypeSelector;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clearNotes:(id)sender;

- (IBAction)volumeChange:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)pauseMusic:(id)sender;
- (IBAction)stopMusic:(id)sender;
- (IBAction)saveFile:(id)sender;
- (IBAction)openFile:(id)sender;
- (IBAction)showSettings:(id)sender;

@end

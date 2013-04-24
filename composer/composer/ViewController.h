//
//  ViewController.h
//  composer
//
//  Created by Jay Wang on 3/10/13.
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
{
    AVAudioPlayer *player;
    AVQueuePlayer *queueplayer;
    CGFloat locX;
    CGFloat locY;
    int numOfNotes;
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

@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer2;

-(BOOL) isOnStaff:(CGPoint)pos;
-(BOOL) isBetweenStaff:(CGPoint)pos;

-(void) handle2Taps:(UITapGestureRecognizer *)sender;
-(void) handleTaps:(UITapGestureRecognizer *)sender;

-(void) findNotePosition:(CGFloat)noteType;

-(void) deleteNoteAt:(CGPoint)pos;

-(void) drawWholeNote:(CGPoint)pos;
-(void) drawHalfNote:(CGPoint)pos;
-(void) drawQuarterNote;
-(void) draw8thNote:(CGPoint)pos;
-(void) draw16thNote:(CGPoint)pos;
-(void) draw32ndNote:(CGPoint)pos;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (retain, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UIButton *StopButton;
@property (retain, nonatomic) IBOutlet UIButton *SaveButton;
@property (retain, nonatomic) IBOutlet UIButton *OpenButton;
@property (weak, nonatomic) IBOutlet UIButton *SettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *NoteTypeSelector;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)volumeChange:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)pauseMusic:(id)sender;
- (IBAction)stopMusic:(id)sender;
- (IBAction)saveFile:(id)sender;
- (IBAction)openFile:(id)sender;
- (IBAction)showSettings:(id)sender;

@end

//
//  ViewController.h
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "ActionSheetPicker.h"

typedef int barOrSpaceNumber;
typedef int noteMIDINumber;
typedef int keyNumber;

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
    barOrSpaceNumber tempBarOrSpace;
    noteMIDINumber tempMIDINumber;
    keyNumber currentKey;
    keyNumber currentCleffView;
    int selectedInstrument;
    int tempStartSoundInt;
    CGFloat spaceBetweenX;
    CGFloat spaceBetweenY;
    CGFloat startingStaffY;
    CGFloat allowError;
    CGFloat screenWidth;
    CGContextRef context;
    NSMutableArray *noteLocations;
    NSMutableArray *accidentLocations;
    NSMutableArray *pianoURLs;
    NSMutableArray *guitarURLs;
    NSMutableArray *bassURLs;
    NSMutableArray *stringsURLs;
    NSMutableArray *fatBassURLs;
    NSMutableArray *saxURLs;
    NSMutableArray *hornURLs;
    NSMutableArray *synthURLs;
    NSMutableArray *soundNumbers;
    UIImageView *cleff;
    NSMutableArray *songURLS;
    NSMutableArray *noteTypes;
}

@property (strong, nonatomic) IBOutlet UIButton *keyButton;
@property (strong, nonatomic) IBOutlet UIButton *instrumentButton;
@property (weak, nonatomic) IBOutlet UIImageView *cleffOver;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accidentSelector;

//-(IBAction)keyClick:(id)sender;

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
@property (weak, nonatomic) IBOutlet UIButton *HelpButton;

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

@property (nonatomic, strong) IBOutlet UITextField *keyTextField;
@property (nonatomic, strong) IBOutlet UITextField *dateTextField;


////////////////////////////

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *instruments;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedInstrument;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) NSInteger selectedBigUnit;
@property (nonatomic, assign) NSInteger selectedSmallUnit;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

- (IBAction)selectABlock:(id)sender;
- (IBAction)selectAKey:(id)sender;
- (IBAction)selectAnInstrument:(id)sender;
- (IBAction)keyButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)selectAMeasurement:(id)sender;
- (IBAction)selectAMusicalScale:(UIControl *)sender;



@end

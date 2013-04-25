//
//  ViewController.m
//  composer
//
//  Created by Jay Wang on 3/10/13.
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize scrollView, volumeSlider, pauseButton, PlayButton, StopButton, SettingsButton, OpenButton, SaveButton, NoteTypeSelector, tapGestureRecognizer, tapGestureRecognizer2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth = 10000;
    [self initButtionEnable];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(screenWidth, 600)];
    startingStaffY = 180.0f;
    spaceBetweenY = 80.0f;
    allowError = spaceBetweenY/2;
    spaceBetweenX = spaceBetweenY/2;
    numOfNotes = 0;
    noteLocations = [[NSMutableArray alloc] init];
    soundURLs = [[NSMutableArray alloc] init];
    soundNumbers = [[NSMutableArray alloc] init];
    for (int i = 48; i <= 97; i++){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/PIANO_%d.wav", [[NSBundle mainBundle] resourcePath], i]];
        [soundURLs addObject:url];
        [soundNumbers addObject:[NSNumber numberWithInt:(i-48)]];
    }
    NSURL *url = [soundURLs objectAtIndex:1];
    NSError *error;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    [player setVolume:self.volumeSlider.value];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTaps:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    
    tapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle2Taps:)];
    tapGestureRecognizer2.numberOfTouchesRequired = 2;
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGestureRecognizer2];
    
}

-(BOOL) isOnStaff:(CGPoint)pos
{
    CGFloat y = pos.y;
    for (int i = 0; i < 5; i++){
        CGFloat staffY = startingStaffY + i * spaceBetweenY;
        if ((y > staffY-allowError/2) && (y < staffY+allowError/2)){
            locY = startingStaffY + i * spaceBetweenY;
            return true;
        }
    }
    return false;
}

-(BOOL) isBetweenStaff:(CGPoint)pos
{
    if ([self isOnStaff:pos]==false){
        if ((pos.y > startingStaffY-allowError) && (pos.y < startingStaffY + allowError + 4*spaceBetweenY)){
            if (pos.y > startingStaffY + 4 * spaceBetweenY){
                locY = startingStaffY + 4 * spaceBetweenY + allowError;
                return true;
            }
            for (int i = 0; i < 5; i++){
                if (pos.y < startingStaffY + i * spaceBetweenY){
                    locY = startingStaffY + i * spaceBetweenY - allowError;
                    return true;
                }
            }
        }
    }
    return false;
}


//Delete from staff
-(void) handle2Taps:(UITapGestureRecognizer *)sender
{
    CGPoint position = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateEnded){
        [self deleteNoteAt:position];
        NSLog(@"Used 2 taps: %@", NSStringFromCGPoint(position));
    }
}

//Add to staff
-(void) handleTaps:(UITapGestureRecognizer *)sender
{
    CGPoint position = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateEnded){
        if ([self isOnStaff:position]==true){
            NSLog(@"On staff - 1: %@", NSStringFromCGPoint(position));
            [self drawQuarterNote];
            NSLog(@"locX: %f , %f", locX, locY);
        }
        if ([self isBetweenStaff:position]==true){
            NSLog(@"Between staff - 1: %@", NSStringFromCGPoint(position));
            [self drawQuarterNote];
            NSLog(@"locX: %f , %f", locX, locY);
        }
     else
        {
            ///MAKE THE BAR OR SPACE HOVERED OVER LIGHT UP
            ///MAKE THE BAR OR SPACE PLAY THE CORRESPONDING SOUND
        }
    
    }
}

-(void) findNotePosition:(CGFloat)noteType
{
    if (numOfNotes!=0){
        //if (locX > screenWidth - allowError)
    }
    else{
        locX = spaceBetweenX;
    }
    CGPoint r;
    r.x = locX;
    r.y = locY-allowError/2;
    CGRect rect;
    rect.origin = r;
    rect.size.height = spaceBetweenX;
    rect.size.width = spaceBetweenX;
    numOfNotes++;
}

-(void) deleteNoteAt:(CGPoint)pos
{
    /*
     for (int x = 0; x < numOfNotes; x++){
     if (pos.x > noteLocations[x].origin.x - allowError/2 && pos.x < noteLocations[x].origin.x + allowError/2){
     noteLocations[x] = noteLocations[numOfNotes-1];
     numOfNotes--;
     }
     }*/
    if (numOfNotes >0)
        numOfNotes--;
}

-(void) drawWholeNote:(CGPoint)pos
{
    
}
-(void) drawHalfNote:(CGPoint)pos
{
    
}
-(void) drawQuarterNote
{
    [self findNotePosition:1];
}
-(void) draw8thNote:(CGPoint)pos
{
    
}
-(void) draw16thNote:(CGPoint)pos
{
    
}
-(void) draw32ndNote:(CGPoint)pos
{
    
}

-(void)initButtionEnable
{
    PlayButton.enabled = YES;
    StopButton.enabled = NO;
    SaveButton.enabled = YES;
    OpenButton.enabled = YES;
    SettingsButton.enabled = YES;
    pauseButton.enabled = NO;
    [StopButton setBackgroundColor:[UIColor grayColor]];
    [pauseButton setBackgroundColor:[UIColor grayColor]];
    [PlayButton setBackgroundColor:[UIColor whiteColor]];
    [SaveButton setBackgroundColor:[UIColor whiteColor]];
    [OpenButton setBackgroundColor:[UIColor whiteColor]];
    [SettingsButton setBackgroundColor:[UIColor whiteColor]];
}

-(void)disableButtons
{
    PlayButton.enabled = NO;
    StopButton.enabled = YES;
    pauseButton.enabled = YES;
    SaveButton.enabled = NO;
    OpenButton.enabled = NO;
    SettingsButton.enabled = NO;
    [StopButton setBackgroundColor:[UIColor whiteColor]];
    [pauseButton setBackgroundColor:[UIColor whiteColor]];
    [PlayButton setBackgroundColor:[UIColor grayColor]];
    [SaveButton setBackgroundColor:[UIColor grayColor]];
    [OpenButton setBackgroundColor:[UIColor grayColor]];
    [SettingsButton setBackgroundColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopMusic:(id)sender {
    [self initButtionEnable];
    [player stop];
    [player setCurrentTime:0];
}

- (IBAction)saveFile:(id)sender {
}

- (IBAction)openFile:(id)sender {
}

- (IBAction)showSettings:(id)sender {
}

- (IBAction)playMusic:(id)sender {
    [self disableButtons];
        [player play];
}

- (IBAction)pauseMusic:(id)sender {
    [self initButtionEnable];
    StopButton.enabled = YES;
    [StopButton setBackgroundColor:[UIColor whiteColor]];
    [player pause];
}

- (IBAction)volumeChange:(id)sender {
    [player setVolume:volumeSlider.value];
}
@end

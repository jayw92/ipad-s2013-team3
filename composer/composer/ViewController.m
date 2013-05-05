//
//  ViewController.m
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson.
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize audioPlayer, clearButton, scrollView, volumeSlider, pauseButton, PlayButton, StopButton, SettingsButton, OpenButton, SaveButton, NoteTypeSelector, tapGestureRecognizer, tapGestureRecognizer2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth = 20000;
    [self initButtonEnable];
    PlayButton.enabled = NO;
    [PlayButton setBackgroundColor:[UIColor grayColor]];
    [clearButton setBackgroundColor:[UIColor whiteColor]];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(screenWidth, 600)];
    startingStaffY = 180.0f;
    spaceBetweenY = 80.0f;
    locX = 0;
    allowError = spaceBetweenY/2;
    spaceBetweenX = spaceBetweenY/2;
    numOfNotes = 0;
    currTrack = 0;
    musicPlaying = false;
    noteLocations = [[NSMutableArray alloc] init];
    soundURLs = [[NSMutableArray alloc] init];
    soundNumbers = [[NSMutableArray alloc] init];
    for (int i = 48; i <= 97; i++){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/PIANO_%d.wav", [[NSBundle mainBundle] resourcePath], i]];
        [soundURLs addObject:url];
    }
    
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
        //NSLog(@"Used 2 taps: %@", NSStringFromCGPoint(position));
    }
}

//Add to staff
-(void) handleTaps:(UITapGestureRecognizer *)sender
{
    CGPoint position = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateEnded){
        if ([self isOnStaff:position]==true){
            //NSLog(@"On staff - 1: %@", NSStringFromCGPoint(position));
            [self callDrawNote];
            //NSLog(@"locX: %f , %f", locX, locY);
        }
        if ([self isBetweenStaff:position]==true){
            //NSLog(@"Between staff - 1: %@", NSStringFromCGPoint(position));
            [self callDrawNote];
            //NSLog(@"locX: %f , %f", locX, locY);
        }
    }
}

-(void)callDrawNote
{
    if ([NoteTypeSelector selectedSegmentIndex] == 0)
        [self findNotePosition:24];
    else if ([NoteTypeSelector selectedSegmentIndex] == 1)
        [self findNotePosition:13];
    else if ([NoteTypeSelector selectedSegmentIndex] == 2)
        [self findNotePosition:14];
    else if ([NoteTypeSelector selectedSegmentIndex] == 3)
        [self findNotePosition:15];
    else if ([NoteTypeSelector selectedSegmentIndex] == 4)
        [self findNotePosition:17];
    else if ([NoteTypeSelector selectedSegmentIndex] == 5)
        [self findNotePosition:18];
}

-(void) findNotePosition:(int)noteType
{
    CGPoint r;
    CGRect rect;
    rect.size.height = spaceBetweenX * 1.7;
    rect.size.width = spaceBetweenX;
    locX = locX + spaceBetweenX;
    if (noteType == 24){
        r.x = locX;
        r.y = locY-rect.size.height+35.0;
    }
    else{
        r.x = locX;
        r.y = locY-rect.size.height+10.0;
    }
    /*if (noteType == 24){
        if (numOfNotes!=0)
            locX = locX + spaceBetweenX * 3;
        else
            locX = spaceBetweenX;
    }
    else if (noteType == 13){
        if (numOfNotes!=0)
            locX = locX + spaceBetweenX * 2;
        else
            locX = spaceBetweenX;
    }
    else{
        if (numOfNotes!=0)
            locX = locX + spaceBetweenX;
        else
            locX = spaceBetweenX;
    }*/
    rect.origin = r;
    UIImageView	*image = [[UIImageView alloc] initWithFrame:rect];
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"Note %d.png", noteType]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [noteLocations addObject:image];
    [scrollView addSubview:[noteLocations objectAtIndex:numOfNotes]];
    numOfNotes++;
    [self initButtonEnable];
    [self addToSoundArray];
}

-(void) addToSoundArray
{
    int startint = 2;
    //note after staff
    if (locY == (startingStaffY + 4 * spaceBetweenY + allowError)){
        [soundNumbers addObject:[NSNumber numberWithInt:(startint)]];
        NSLog(@"inside note out of staff added");
    }
    else{
    for (int i = 0; i < 5; i++){
        //notes on staff
        if (locY == (startingStaffY + i * spaceBetweenY)){
            if (i == 0)
                startint = 17;
            else if (i == 1)
                startint = 14;
            else if (i == 2)
                startint = 11;
            else if (i == 3)
                startint = 7;
            else if (i == 4)
                startint = 4;
            [soundNumbers addObject:[NSNumber numberWithInt:(startint)]];
            NSLog(@"inside note on staff added");
        }
        //notes inBetween staff
        else if (locY == (startingStaffY + i * spaceBetweenY - allowError)){
            if (i == 0)
                startint = 19;
            else if (i == 1)
                startint = 16;
            else if (i == 2)
                startint = 12;
            else if (i == 3)
                startint = 9;
            else if (i == 4)
                startint = 5;
            [soundNumbers addObject:[NSNumber numberWithInt:(startint)]];
            NSLog(@"inside note between staff added");
        }
    }
    }
    [self playSelectedNote];
}

-(void) playSelectedNote
{
    int index = [[soundNumbers objectAtIndex:(numOfNotes-1)] intValue];
    NSURL *url = [soundURLs objectAtIndex:index];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer setVolume:(volumeSlider.value)];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(void) deleteNoteAt:(CGPoint)pos
{
    if (numOfNotes >0){
        numOfNotes--;
        [[noteLocations objectAtIndex:numOfNotes] removeFromSuperview];
        [noteLocations removeLastObject];
        [soundNumbers removeLastObject];
        locX = locX - spaceBetweenX;
    }
}

-(void)initButtonEnable
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
    [self initButtonEnable];
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
    currTrack = 0;
}

- (IBAction)saveFile:(id)sender {
}

- (IBAction)openFile:(id)sender {
}

- (IBAction)showSettings:(id)sender {
}

- (IBAction)playMusic:(id)sender {
    [self disableButtons];
    int index = [[soundNumbers objectAtIndex:currTrack] intValue];
    NSURL *url = [soundURLs objectAtIndex:index];
    currTrack++;
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = 0;
    [audioPlayer setVolume:(volumeSlider.value)];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag){
        if (currTrack == numOfNotes){
            [self initButtonEnable];
            [audioPlayer stop];
            [audioPlayer setCurrentTime:0];
            currTrack = 0;
        }
        else if (currTrack < numOfNotes){
            int index = [[soundNumbers objectAtIndex:currTrack] intValue];
            NSURL *url = [soundURLs objectAtIndex:index];
            NSError *error;
            currTrack++;
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
            audioPlayer.delegate = self;
            audioPlayer.numberOfLoops = 0;
            [audioPlayer setVolume:(volumeSlider.value)];
            [audioPlayer prepareToPlay];
            [audioPlayer play];
        }
    }
}

- (IBAction)pauseMusic:(id)sender {
    [self initButtonEnable];
    StopButton.enabled = YES;
    [StopButton setBackgroundColor:[UIColor whiteColor]];
    [audioPlayer pause];
}

- (IBAction)clearNotes:(id)sender {
    [self initButtonEnable];
    PlayButton.enabled = NO;
    [PlayButton setBackgroundColor:[UIColor grayColor]];
    while (numOfNotes >0){
        numOfNotes--;
        [[noteLocations objectAtIndex:numOfNotes] removeFromSuperview];
        [noteLocations removeLastObject];
        [soundNumbers removeLastObject];
    }
    currTrack = 0;
    locX = 0;
}

- (IBAction)volumeChange:(id)sender {
    [audioPlayer setVolume:(volumeSlider.value)];
}
@end

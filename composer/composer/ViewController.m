//
//  ViewController.m
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson.
//  Copyright (c) 2013 SoundStorm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element;
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)keyWasSelected:(NSNumber *)selectedIndex element:(id)element;
@end

@implementation ViewController

@synthesize audioPlayer, clearButton, scrollView, volumeSlider, pauseButton, PlayButton, StopButton, SettingsButton, OpenButton, SaveButton, NoteTypeSelector, accidentSelector, tapGestureRecognizer, tapGestureRecognizer2, keyButton, cleffOver;


- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth = 20000;
    [self initButtonEnable];
    PlayButton.enabled = NO;
//    [PlayButton setBackgroundColor:[UIColor grayColor]];
//    [clearButton setBackgroundColor:[UIColor whiteColor]];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(screenWidth, 600)];
    startingStaffY = 180.0f;
    spaceBetweenY = 84.0f;
    locX = 370;
    allowError = spaceBetweenY/2;
    spaceBetweenX = spaceBetweenY/2;
    numOfNotes = 0;
    currTrack = 0;
    tempStartSoundInt = 2;
    musicPlaying = false;
    noteLocations = [[NSMutableArray alloc] init];
    accidentLocations = [[NSMutableArray alloc] init];
    pianoURLs = [[NSMutableArray alloc] init];
    bassURLs = [[NSMutableArray alloc] init];
    guitarURLs = [[NSMutableArray alloc] init];
    stringsURLs = [[NSMutableArray alloc] init];
    soundNumbers = [[NSMutableArray alloc] init];
    noteTypes = [[NSMutableArray alloc] init];
    for (int i = 48; i <= 97; i++){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/PIANO_%d.wav", [[NSBundle mainBundle] resourcePath], i]];
        [pianoURLs addObject:url];
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/GUITAR_%d.aif", [[NSBundle mainBundle] resourcePath], i]];
        [guitarURLs addObject:url];
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/STRINGS_%d.aif", [[NSBundle mainBundle] resourcePath], i]];
        [stringsURLs addObject:url];
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/BASS_%d.aif", [[NSBundle mainBundle] resourcePath], i]];
        [bassURLs addObject:url];
    }
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTaps:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    
    tapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle2Taps:)];
    tapGestureRecognizer2.numberOfTouchesRequired = 2;
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGestureRecognizer2];
    self.selectedIndex = 5;
    [self drawCleff];
    self.keys = [NSArray arrayWithObjects:  @"D♭ major", @"A♭ major", @"E♭ major", @"B♭ major", @"F major", @"C major", @"G major", @"D major",@"A major", @"E major", @"B major", @"F♯ major",   nil];
    self.instruments = [NSArray arrayWithObjects:  @"Piano", @"Strings", @"Bass", @"Guitar",   nil];

}








///////////////////////////KEY SELECTOR VIEW///////////////////////////////






@synthesize keyTextField = _keyTextField;

@synthesize keys = _keys;
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedInstrument = _selectedInstrument;
@synthesize selectedDate = _selectedDate;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize selectedSmallUnit = _selectedSmallUnit;
@synthesize actionSheetPicker = _actionSheetPicker;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - IBActions



- (IBAction)selectAKey:(UIControl *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select A Key" rows:self.keys initialSelection:self.selectedIndex target:self successAction:@selector(keyWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    /* Example ActionSheetPicker using customButtons
     self.actionSheetPicker = [[ActionSheetPicker alloc] initWithTitle@"Select Key" rows:self.keys initialSelection:self.selectedIndex target:self successAction:@selector(itemWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender
     
     [self.actionSheetPicker addCustomButtonWithTitle:@"Special" value:[NSNumber numberWithInt:1]];
     self.actionSheetPicker.hideCancel = YES;
     [self.actionSheetPicker showActionSheetPicker];
     */
}

- (IBAction)keyButtonTapped:(UIBarButtonItem *)sender {
    [self selectAKey:sender];
}




#pragma mark - Implementation

- (void)keyWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    NSString *keyName = [self.keys objectAtIndex:self.selectedIndex];
    currentKey = self.selectedIndex - 5;

    NSLog(@"The key was selected as %d", currentKey);
    NSLog(@"The key was selected as %@", keyName);
    [keyButton setTitle:keyName forState:UIControlStateNormal];
    [self drawCleff];
}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}



/////////////////////////////////////////////////////////////






- (IBAction)selectAnInstrument:(UIControl *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select An Instrument" rows:self.instruments initialSelection:self.selectedInstrument target:self successAction:@selector(instrumentWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    /* Example ActionSheetPicker using customButtons
     self.actionSheetPicker = [[ActionSheetPicker alloc] initWithTitle@"Select Key" rows:self.keys initialSelection:self.selectedIndex target:self successAction:@selector(itemWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender
     
     [self.actionSheetPicker addCustomButtonWithTitle:@"Special" value:[NSNumber numberWithInt:1]];
     self.actionSheetPicker.hideCancel = YES;
     [self.actionSheetPicker showActionSheetPicker];
     */
}

- (IBAction)instrumentButtonTapped:(UIBarButtonItem *)sender {
    [self selectAnInstrument:sender];
}




#pragma mark - Implementation

- (void)instrumentWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedInstrument = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    NSString *instrumentName = [self.instruments objectAtIndex:self.selectedInstrument];
    
    NSLog(@"The instrument was selected as %d", self.selectedInstrument);
    NSLog(@"The instrument was selected as %@", instrumentName);
    [_instrumentButton setTitle:instrumentName forState:UIControlStateNormal];
    
}


/////////////////////////////////////////////////////////////






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
            if (pos.y > startingStaffY + 4 * spaceBetweenY)
            {
                locY = startingStaffY + 4 * spaceBetweenY + allowError;
                return true;
            }
            for (int i = 0; i < 5; i++){
                if (pos.y < startingStaffY + i * spaceBetweenY)
                {
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
    [self initButtonEnable];
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
    currTrack = 0;
    if (sender.state == UIGestureRecognizerStateEnded){
        [self deleteNoteAt:position];
        //NSLog(@"Used 2 taps: %@", NSStringFromCGPoint(position));
    }
}

-(barOrSpaceNumber) getVerticalDropzoneOnStaff:(CGPoint *) position
{
    int bottom = (startingStaffY-(3*(spaceBetweenY/4)));
    int dist_from_bottom = position->y - bottom;
    
//    NSLog(@"The Distance from Bottom is %d", dist_from_bottom);
    
    if (dist_from_bottom > -1)
    {        
        int divsUp = dist_from_bottom/(spaceBetweenY/12);
        int spotsUp = divsUp/6;
//        NSLog(@"The spot is in divsUP %d and the spots up is %d",divsUp, spotsUp);
        
        locY = bottom + spotsUp*(spaceBetweenY/2);
        return spotsUp;
    }
    
    return -1;
}

//Add to staff
-(void) handleTaps:(UITapGestureRecognizer *)sender
{
    CGPoint position = [sender locationInView:sender.view];
    [self initButtonEnable];
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
    currTrack = 0;
    
    tempBarOrSpace = [self getVerticalDropzoneOnStaff:&position];
    
    
 
    //             int distanceFromBottom =  pos.y - (startingStaffY - allowError);
    //             int barOrSpaceNumber =      distanceFromBottom/spaceBetweenY;
    //
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {

        if ([self isOnStaff:position]==true)
        {
            //NSLog(@"On staff - 1: %@", NSStringFromCGPoint(position));
            [self callDrawNote];
            //NSLog(@"locX: %f , %f", locX, locY);
        }
        if ([self isBetweenStaff:position]==true)
        {
            //NSLog(@"Between staff - 1: %@", NSStringFromCGPoint(position));
            [self callDrawNote];
            //NSLog(@"locX: %f , %f", locX, locY);
        }
        
    }
    else
    {
        //swag
    }
}

-(void)callDrawNote
{

    switch ([NoteTypeSelector selectedSegmentIndex])
    {
        case 0:
            [self findNotePosition:24];
            break;
        case 1:
            [self findNotePosition:13];
            break;
        case 2:
            [self findNotePosition:14];
            break;
        case 3:
            [self findNotePosition:15];
            break;
        case 4:
            [self findNotePosition:17];
            break;
        case 5:
            [self findNotePosition:18];
            break;
            
        default:
            break;
    }
 
/*
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
*/
    
}

-(void) drawCleff
{
    if (cleff.image != NULL)
    {
        [cleff removeFromSuperview];
    }
    CGPoint r;
    CGRect rect;
    rect.size.height = 610;
    rect.size.width = 750;
    r.x = 20;
    r.y = 70;
    cleff = [[UIImageView alloc] initWithFrame:rect];
    cleff.image = [UIImage imageNamed:[NSString stringWithFormat:@"key%d.png", currentKey]];
    cleff.contentMode = UIViewContentModeLeft;
    [cleffOver addSubview:cleff];
}

-(void) findNotePosition:(int)noteType
{
    CGPoint r;
    CGRect rect;
    rect.size.height = spaceBetweenX * 1.7;
    rect.size.width = spaceBetweenX;
    locX = locX + spaceBetweenX;
    if (noteType == 24){
        locX = locX + spaceBetweenX*2;
        r.y = locY-rect.size.height+35.0;
    }
    else{
        r.y = locY-rect.size.height+10.0;
    }
    if (noteType == 13){
        locX = locX + spaceBetweenX;
    }
    r.x = locX;
    
    CGPoint r2;
    CGRect rect2;
    rect2.size.width = spaceBetweenX*0.3;
    rect2.size.height = spaceBetweenX;
    r2.x=r.x;
    r2.y = r.y + 35.0;
    
    rect2.origin = r2;
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:rect2];
    if (accidentSelector.selectedSegmentIndex != 2){
        if (accidentSelector.selectedSegmentIndex == 0)
            image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"sharp.png"]];
        else if (accidentSelector.selectedSegmentIndex == 1)
            image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"natural.png"]];
        else if (accidentSelector.selectedSegmentIndex == 3)
            image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"flat.png"]];
        image2.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:image2];
        locX = locX + spaceBetweenX*0.3;
        r.x = locX;
    }
    rect.origin = r;
    UIImageView	*image = [[UIImageView alloc] initWithFrame:rect];
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"Note %d.png", noteType]];
    [noteTypes addObject:[NSNumber numberWithInt:(noteType)]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [accidentLocations addObject:image2];
    [noteLocations addObject:image];
    [scrollView addSubview:[noteLocations objectAtIndex:numOfNotes]];
    numOfNotes++;
    [self initButtonEnable];
//    [self findMIDINumber];
    [self addToSoundArray];
}

-(void) addMIDIModifiers
{
    //bool isSharpened = false;
    //bool isFlatted = false;
    //bool isNatural = true;
    
    switch (tempStartSoundInt)
    {
        case 19:
            if (currentKey > 2)
            {tempStartSoundInt++;}
            else if (currentKey < -4)
            {tempStartSoundInt--;}// top G space
            break;
        case 17:
            if (currentKey > 0)
            {tempStartSoundInt++;}
            break;
            
        case 16:
            if (currentKey > 5)
            {tempStartSoundInt++;}
            else if (currentKey < -1)
            {tempStartSoundInt--;}  // top e space
            break;
            
        case 14:
            if (currentKey > 3)
            {tempStartSoundInt++;}
            else if (currentKey < -3)
            {tempStartSoundInt--;}// top d bar
            break;
            
        case 12:
            if (currentKey > 1)
            {tempStartSoundInt++;} // top c space
            break;
            
        case 11:
            tempMIDINumber = 11; // middle b bar
            if (currentKey < 0)
            {tempStartSoundInt--;}
            break;
            
        case 9:
            if (currentKey > 4)
            {tempStartSoundInt++;}
            else if (currentKey < -2)
            {tempStartSoundInt--;}// bottom a space
            break;
            
        case 7:
            if (currentKey > 2)
            {tempStartSoundInt++;}
            else if (currentKey < -4)
            {tempStartSoundInt--;}// bottom g bar
            break;
            
        case 5:
            if (currentKey > 0)
            {tempStartSoundInt++;} // bottom f space
            break;
            
        case 4:
            if (currentKey > 5)
            {tempStartSoundInt++;}
            else if (currentKey < -1)
            {tempStartSoundInt--;}// bottom e bar
            break;
            
        case 2:
            if (currentKey > 3)
            {tempStartSoundInt++;}
            else if (currentKey < -3)
            {tempStartSoundInt--;}// bottom D space
            break;
    
    
        default:
            break;
    }
    
    
    switch  (accidentSelector.selectedSegmentIndex)
    {
        case 0:
            tempStartSoundInt++;
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            tempStartSoundInt --;
            break;
    }
    
//NSLog(@"THE TEMP MIDI NUMBER IS %d \n", tempMIDINumber);

}

-(void) addToSoundArray
{
    tempStartSoundInt = 2;
    //note after staff
    
    
    if (locY == (startingStaffY + 4 * spaceBetweenY + allowError))
    {
        [self addMIDIModifiers];
        [soundNumbers addObject:[NSNumber numberWithInt:(tempStartSoundInt)]];
//        NSLog(@"inside note out of staff added");
    }
    else{
    for (int i = 0; i < 5; i++){
        //notes on staff
        if (locY == (startingStaffY + i * spaceBetweenY))
        {
            if (i == 0)
                tempStartSoundInt = 17;
            else if (i == 1)
                tempStartSoundInt = 14;
            else if (i == 2)
                tempStartSoundInt = 11;
            else if (i == 3)
                tempStartSoundInt = 7;
            else if (i == 4)
                tempStartSoundInt = 4;
            [self addMIDIModifiers];
            [soundNumbers addObject:[NSNumber numberWithInt:(tempStartSoundInt)]];
//            NSLog(@"inside note on staff added");
        }
        //notes inBetween staff
        else if (locY == (startingStaffY + i * spaceBetweenY - allowError)){
            if (i == 0)
                tempStartSoundInt = 19;
            else if (i == 1)
                tempStartSoundInt = 16;
            else if (i == 2)
                tempStartSoundInt = 12;
            else if (i == 3)
                tempStartSoundInt = 9;
            else if (i == 4)
                tempStartSoundInt = 5;
            [self addMIDIModifiers];
            [soundNumbers addObject:[NSNumber numberWithInt:(tempStartSoundInt)]];
//            NSLog(@"inside note between staff added");
        }
    }
    }
    ;
//    [soundNumbers addObject:[NSNumber numberWithInt:(tempMIDINumber)]];
    accidentSelector.selectedSegmentIndex = 2;
    [self playSelectedNote];
}

-(void) playSelectedNote
{
    int index = [[soundNumbers objectAtIndex:(numOfNotes-1)] intValue];
    NSURL *url = [[self getSoundURL] objectAtIndex:index];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer setVolume:(volumeSlider.value)];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(NSMutableArray*)getSoundURL
{
    switch (self.selectedInstrument)
    {
        case 0:
            return pianoURLs;
        case 1:
            return stringsURLs;
        case 2:
            return bassURLs;
        case 3:
            return guitarURLs;
    }
    return pianoURLs;
}

-(void) deleteNoteAt:(CGPoint)pos
{
    if (numOfNotes > 0){
        numOfNotes--;
        [[noteLocations objectAtIndex:numOfNotes] removeFromSuperview];
        [[accidentLocations objectAtIndex:numOfNotes] removeFromSuperview];
        
        [accidentLocations removeLastObject];
        [noteLocations removeLastObject];
        [soundNumbers removeLastObject];
        if (numOfNotes == 0){
            locX = 370;
        }
        else{
            locX = [[accidentLocations objectAtIndex:(numOfNotes-1)] frame].origin.x;
        }
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
//    [StopButton setBackgroundColor:[UIColor grayColor]];
//    [pauseButton setBackgroundColor:[UIColor grayColor]];
//    [PlayButton setBackgroundColor:[UIColor whiteColor]];
//    [SaveButton setBackgroundColor:[UIColor whiteColor]];
//    [OpenButton setBackgroundColor:[UIColor whiteColor]];
//    [SettingsButton setBackgroundColor:[UIColor whiteColor]];
}

-(void)disableButtons
{
    PlayButton.enabled = NO;
    StopButton.enabled = YES;
    pauseButton.enabled = YES;
    SaveButton.enabled = NO;
    OpenButton.enabled = NO;
    SettingsButton.enabled = NO;
//    [StopButton setBackgroundColor:[UIColor whiteColor]];
//    [pauseButton setBackgroundColor:[UIColor whiteColor]];
//    [PlayButton setBackgroundColor:[UIColor grayColor]];
//    [SaveButton setBackgroundColor:[UIColor grayColor]];
//    [OpenButton setBackgroundColor:[UIColor grayColor]];
//    [SettingsButton setBackgroundColor:[UIColor grayColor]];
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
    int rateType = [[noteTypes objectAtIndex:currTrack] intValue];
    NSURL *url = [[self getSoundURL] objectAtIndex:index];
    currTrack++;
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    [audioPlayer setVolume:(volumeSlider.value)];
    audioPlayer.delegate = self;
    audioPlayer.enableRate = YES;
    [audioPlayer prepareToPlay];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.rate = [self getSampleRate:rateType];
    NSLog (@"In \"play music\" The current index is %d", rateType);
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
            NSURL *url = [[self getSoundURL] objectAtIndex:index];
            int rateType = [[noteTypes objectAtIndex:currTrack] intValue];
            NSError *error;
            currTrack++;
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
            audioPlayer.delegate = self;
            [audioPlayer setVolume:(volumeSlider.value)];
            audioPlayer.enableRate = YES;
            [audioPlayer prepareToPlay];
            audioPlayer.numberOfLoops = 0;
            NSLog (@"In \"audioPlayerdidfinish\" The current index is %d", rateType);
            audioPlayer.rate = [self getSampleRate:rateType];
            [audioPlayer play];
        }
    }
}

-(float)getSampleRate:(int) noteImageIndex
{
    
    switch (noteImageIndex)
    {
        case 24:
            return 1.0f;
        case 13:
            return 2.0f;
        case 14:
            return 4.0f;
        case 15:
            return 8.0f;
        case 17:
            return 16.0f;
        case 18:
            return 32.0f;
            
        default:
            return 1.0f;
    }
    return 1.0f;
    
}

- (IBAction)pauseMusic:(id)sender {
    [self initButtonEnable];
    StopButton.enabled = YES;
//    [StopButton setBackgroundColor:[UIColor whiteColor]];
    [audioPlayer pause];
}

- (IBAction)clearNotes:(id)sender {
    [self initButtonEnable];
    PlayButton.enabled = NO;
//    [PlayButton setBackgroundColor:[UIColor grayColor]];
    while (numOfNotes > 0){
        numOfNotes--;
        [[noteLocations objectAtIndex:numOfNotes] removeFromSuperview];
        [[accidentLocations objectAtIndex:numOfNotes] removeFromSuperview];
    }
    [noteLocations removeAllObjects];
    [soundNumbers removeAllObjects];
    [accidentLocations removeAllObjects];
    [noteTypes removeAllObjects];
    currTrack = 0;
    locX = 370;
}

- (IBAction)volumeChange:(id)sender {
    [audioPlayer setVolume:(volumeSlider.value)];
}
@end

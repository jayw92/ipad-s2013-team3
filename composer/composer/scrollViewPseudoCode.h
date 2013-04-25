//
//  scrollViewMain.h
//  composer
//
//  Created by Jay Wang on 4/23/13.
//  Copyright (c) 2013 Jay Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
//***************************************************************************
//Make a STRUCT with the following shit in it:
 
struct noteOnStaffStruct
 {
    int midi_number;   // this'll be the number of the note. a staff starts 
                            with the bottom of a treble cleff staff "E" being E4, 52.
                            peep the functions below for the conversions
    int measure;
    int 32_beat;         // in 32nd notes, where 0 is 1, 8 is 2, 16 is 3, 24 is 4
    int length;           // the length of the note, in 32nd notes
 };
 //***************************************************************************
*/

/*
 GLOBAL Constants for drawing the measures (eventually this might be editable by zoom):
 
 int measureWidthInPixels = (  ?????? however wide you think they should be  );
 int 32_widthInPixels = measureWidthInPixels / 32;
 
 /// live updating, to keep track of where the next note goes
 
 int currentMeasure = 0; (this gets iterated as notes are added)
 int current 32_beat = 0; (this gets iterated measure by measure)
 
 typedef int MIDINoteNumber
 typedef int barOrSpaceNumber
 
 
*/




@interface scrollViewMain : UIScrollView
{
    CGFloat locX;
    CGFloat locY;
    int numOfNotes;
    CGRect *noteLocations;
    CGFloat spaceBetweenX;
    CGFloat spaceBetweenY;
    CGFloat startingStaffY;
    CGFloat allowError;
    CGFloat screenWidth;
    CGContextRef context;
}

@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer2;

-(BOOL) isOnStaff:(CGPoint)pos;
-(BOOL) isBetweenStaff:(CGPoint)pos;

-(void) handle2Taps:(UITapGestureRecognizer *)sender;
-(void) singleFingerNoteAdd:(UITapGestureRecognizer *)sender;

-(void) findNotePosition:(CGFloat)noteType;

-(void) deleteNoteAt:(CGPoint)pos;

-(void) drawWholeNote:(CGPoint)pos;
-(void) drawHalfNote:(CGPoint)pos;
-(void) drawQuarterNote;
-(void) draw8thNote:(CGPoint)pos;
-(void) draw16thNote:(CGPoint)pos;
-(void) draw32ndNote:(CGPoint)pos;

@end

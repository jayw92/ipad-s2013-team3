//
//  scrollViewMain.h
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson.
//  Copyright (c) 2013 Jay Wang, Eric Mariasis, and Scott Jacobson. All rights reserved.
//

#import <UIKit/UIKit.h>

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
-(void) handleTaps:(UITapGestureRecognizer *)sender;

-(void) findNotePosition:(CGFloat)noteType;

-(void) deleteNoteAt:(CGPoint)pos;

-(void) drawWholeNote:(CGPoint)pos;
-(void) drawHalfNote:(CGPoint)pos;
-(void) drawQuarterNote;
-(void) draw8thNote:(CGPoint)pos;
-(void) draw16thNote:(CGPoint)pos;
-(void) draw32ndNote:(CGPoint)pos;

@end

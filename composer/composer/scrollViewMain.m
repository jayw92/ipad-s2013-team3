//
//  scrollViewMain.m
//  composer
//
//  Created by Jay Wang on 4/23/13.
//  Copyright (c) 2013 Jay Wang. All rights reserved.
//

#import "scrollViewMain.h"
#import "ViewController.h"

@implementation scrollViewMain

@synthesize tapGestureRecognizer;
@synthesize tapGestureRecognizer2;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    startingStaffY = 180.0f;
    spaceBetweenY = 80.0f;
    allowError = spaceBetweenY/2;
    spaceBetweenX = spaceBetweenY/2;
    numOfNotes = 0;
    noteLocations = malloc(sizeof(CGPoint)*1000);
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTaps:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        tapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle2Taps:)];
        tapGestureRecognizer2.numberOfTouchesRequired = 2;
        tapGestureRecognizer2.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer2];
    }
    return self;
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
        [self setNeedsDisplay];
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
            [self setNeedsDisplay];
        }
        if ([self isBetweenStaff:position]==true){
            NSLog(@"Between staff - 1: %@", NSStringFromCGPoint(position));
            [self drawQuarterNote];
            NSLog(@"locX: %f , %f", locX, locY);
            [self setNeedsDisplay];
        }
    }
}

- (void)drawRect:(CGRect)rect{

    screenWidth= 10000;
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    //Make staff
    CGContextSetLineWidth(context, 6.0f);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    for (int i = 0; i < 5; i++){
        CGContextMoveToPoint(context, 20.0f, startingStaffY+i*spaceBetweenY);
        CGContextAddLineToPoint(context, (screenWidth-20.f), startingStaffY+i*spaceBetweenY);
        CGContextStrokePath(context);
    }
}

-(void) findNotePosition:(CGFloat)noteType
{
    if (numOfNotes!=0){
        locX = noteLocations[numOfNotes-1].origin.x + spaceBetweenX * noteType;
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
    noteLocations[numOfNotes] = rect;
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


@end

//
//  AnotherViewController.m
//  PopupView
//
//  Created by Ming Chow on 4/10/12.
//  Copyright (c) 2012 Tufts University. All rights reserved.
//

#import "KeySelectView.h"

@implementation KeySelectView

@synthesize pickerViewArray;
@synthesize keyPickerView;

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
    self.contentSizeForViewInPopover = CGSizeMake(200, 200);
//    pvController = [[KeySelectView alloc] initWithNibName:@"keyPickerView" bundle:[NSBundle mainBundle]];


    
    pickerViewArray = [[NSMutableArray alloc] init];
    [pickerViewArray addObject:@"Red"];
    [pickerViewArray addObject:@"Orange"];
    [pickerViewArray addObject:@"Yellow"];
    [pickerViewArray addObject:@"Green"];
    [pickerViewArray addObject:@"Blue"];
    [pickerViewArray addObject:@"Indigo"];
    [pickerViewArray addObject:@"Violet"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerViewArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerViewArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected Color: %@. Index of selected color: %i", [pickerViewArray objectAtIndex:row], row);
}


-(IBAction)selectedRow {
    int selectedIndex = [pickerView selectedRowInComponent:0];
    NSString *message = [NSString stringWithFormat:@"You selected: %@",[pickerViewArray objectAtIndex:selectedIndex]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end

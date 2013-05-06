//
//  AnotherViewController.h
//  PopupView
//
//  Created by Ming Chow on 4/10/12.
//  Copyright (c) 2012 Tufts University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeySelectView : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *pickerViewArray;
}

@property (nonatomic, retain) NSArray *pickerViewArray;
@property (weak, nonatomic) IBOutlet UIPickerView *keyPickerView;

-(IBAction)selectedRow;

@end

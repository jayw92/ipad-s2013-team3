//
//  composerAppDelegate.h
//  composer
//
//  Created by Jay Wang, Eric Mariasis, and Scott Jacobson.
//  Copyright (c) 2013 Jay Wang, Eric Mariasis, and Scott Jacobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"


@class ViewController;

@interface composerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end

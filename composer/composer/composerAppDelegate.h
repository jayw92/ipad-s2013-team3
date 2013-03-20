//
//  composerAppDelegate.h
//  composer
//
//  Created by Jay Wang on 3/10/13.
//  Copyright (c) 2013 Jay Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class composerViewController;

@interface composerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) composerViewController *viewController;

@end

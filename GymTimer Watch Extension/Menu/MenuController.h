//
//  MenuController.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 21/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *grpSoundBackground;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgNextExercise;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgSound;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgClose;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnChangeRest;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblNextExerciseTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChangeRestTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblSoundTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblEndWorkoutTitle;

@end

NS_ASSUME_NONNULL_END

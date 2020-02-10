//
//  TutorialController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 21/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "TutorialController.h"

@interface TutorialController ()

@end

@implementation TutorialController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    if ([context isEqualToString: @"FromHome"]) {
        [self.imgTutorial setImageNamed:@"HomeTutorial"];
        
    } else if ([context isEqualToString:@"FromWorkoutTimer"]) {
        [self.imgTutorial setImageNamed:@"SetTutorial"];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// MARK:- IBActions

- (IBAction)exitAction {
    [self popController];
}

@end




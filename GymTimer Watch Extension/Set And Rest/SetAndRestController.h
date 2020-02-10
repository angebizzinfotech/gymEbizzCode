//
//  SetAndRestController.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 21/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface SetAndRestController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRestMin;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRestSec;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRestMinTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRestSecTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblNextSetTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblNextSet;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblDoSetTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblSetNo;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *setGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *restGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *tutorialGroup;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

NS_ASSUME_NONNULL_END

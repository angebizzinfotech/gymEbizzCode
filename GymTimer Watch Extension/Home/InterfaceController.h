//
//  InterfaceController.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 13/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@import WatchConnectivity;

@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *mainGrp;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChooseTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblMinTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblSecTime;
@property (strong, nonatomic) IBOutlet WKInterfacePicker *timePicker;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblClickAnyWhereTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *tutorialGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *homeGroup;

@end

//
//  AlertController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 20/02/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "AlertController.h"

@implementation AlertController
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [_lblValShow setText:(NSString *)context];
}
@end

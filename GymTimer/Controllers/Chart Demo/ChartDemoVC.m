//
//  ChartDemoVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/06/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ChartDemoVC.h"
#import "CommonImports.h"
#import "GymTimer-Bridging-Header.h"

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

@interface ChartDemoVC () <SMDiagramViewDataSource> {
    CGFloat viewForSegmentWidth;
}

@end

@implementation ChartDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    viewForSegmentWidth = 30.f;
    self.diagramView.emptyView = [self emptyView];
    self.diagramView.dataSource = self;
    self.diagramView.backgroundColor = [UIColor clearColor];
    
    self.diagramView.minProportion = 0.1;
    [self.diagramView setDiagramViewMode:SMDiagramViewModeArc];
    self.diagramView.diagramOffset = CGPointZero;
    self.diagramView.radiusOfSegments = 80.0;
    self.diagramView.radiusOfViews = 130.0;
    self.diagramView.arcWidth = 1.0; //Ignoring for SMDiagramViewMode.segment
    self.diagramView.startAngle = -M_PI/2;
    self.diagramView.endAngle = 2.0 * M_PI - M_PI/2.0;
    [self.diagramView setColorOfSegments:[UIColor redColor]];
    self.diagramView.viewsOffset = CGPointZero;
    self.diagramView.separatorWidh = 1.0;
    
    [self.diagramView reloadData];
}

//MARK:- SMDiagramViewDataSource

- (NSInteger)numberOfSegmentsInDiagramView:(nonnull SMDiagramView *)diagramView {
    return 6;
}

- (CGFloat)diagramView:(SMDiagramView *)diagramView proportionForSegmentAtIndex:(NSInteger)index {
    
    CGFloat result = 0.f;
    switch (index) {
        case 0:
            result = 1.f/100.f;
            break;
        case 1:
            result = 33.0f/100.f;
            break;
        case 2:
            result = 0.0f/100.f;
            break;
        case 3:
            result = 33.0f/100.f;
            break;
        case 4:
            result = 0.0f/100.f;
            break;
        case 5:
            result = 33.0f/100.f;
            break;
        default:
            break;
    }
    return result;
}

- (CGFloat)diagramView:(SMDiagramView *)diagramView radiusForSegmentAtIndex:(NSInteger)index proportion:(CGFloat)proportion angle:(CGFloat)angle {
    return 50;
}

- (UIColor *)diagramView:(SMDiagramView *)diagramView colorForSegmentAtIndex:(NSInteger)index angle:(CGFloat)angle {

    UIColor *color = [[UIColor alloc] init];
    switch (index) {
        case 0:
            color = cENDURANCE_VIEW;
            break;
        case 1:
            color = [UIColor clearColor];
            break;
        case 2:
            color = cMUSCLE_VIEW;
            break;
        case 3:
            color = [UIColor clearColor];
            break;
        case 4:
            color = cSTRENGTH_VIEW;
            break;
            
        default:
            color = [UIColor clearColor];
            break;
    }
    return color;
}

- (UIView *)diagramView:(SMDiagramView *)diagramView viewForSegmentAtIndex:(NSInteger)index colorOfSegment:(UIColor *)colorOfSegment angle:(CGFloat)angle {
    return [self viewForSegmentAtIndex:index];
}

- (CGFloat)diagramView:(SMDiagramView *)diagramView radiusForView:(UIView *)view atIndex:(NSInteger)index radiusOfSegment:(CGFloat)aRadiusOfSegment angle:(CGFloat)angle {
    return 85;
}

- (CGFloat)diagramView:(SMDiagramView *)diagramView lineWidthForSegmentAtIndex:(NSInteger)index angle:(CGFloat)angle {
    return 12;
}

//MARK:- Utils

- (UIView *)emptyView {
    UILabel *emptyView = [[UILabel alloc] initWithFrame:self.diagramView.bounds];
    emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    emptyView.textAlignment = NSTextAlignmentCenter;
    emptyView.numberOfLines = 0;
    emptyView.text = @"This Is\nEmpty\nView";
    return emptyView;
}

- (UIView *)viewForSegmentAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewForSegmentWidth, viewForSegmentWidth)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.clipsToBounds = YES;
    label.text = @(index+1).stringValue;
    label.layer.cornerRadius = viewForSegmentWidth/2;
    label.backgroundColor = [Utils colorForIndex:index];
    return label;
}

@end

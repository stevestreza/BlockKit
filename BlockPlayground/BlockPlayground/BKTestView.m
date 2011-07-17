//
//  BKTestView.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "BKTestView.h"

@implementation BKTestView

- (void)drawRect:(CGRect)rect;
{
    [[UIColor yellowColor] set];
    [[UIBezierPath bezierPathWithRect:self.bounds] fill];
}

- (void)testLog;
{
    NSLog(@"It works!");
}

@end

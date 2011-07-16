//
//  UIView-BKAdditions.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "UIView-BKAdditions.h"
#import "NSObject-BKAdditions.h"

@interface BKDrawRectBlockView : UIView
@property (nonatomic, copy) BKRectBlock internalDrawRectBlock;

- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
@end

@implementation BKDrawRectBlockView

@synthesize internalDrawRectBlock;

- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
{
    if ((self = [super initWithFrame:CGRectZero])) {
        internalDrawRectBlock = [aDrawRectBlock copy];
    }
    return self;
}

- (void)dealloc;
{
    [internalDrawRectBlock release];
    internalDrawRectBlock = nil;
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect;
{
    if (self.internalDrawRectBlock) {
        self.internalDrawRectBlock(rect);
    }
}

- (void)setInternalDrawRectBlock:(BKRectBlock)newInternalDrawRectBlock;
{
    if (newInternalDrawRectBlock != internalDrawRectBlock) {
        [internalDrawRectBlock autorelease];
        internalDrawRectBlock = [newInternalDrawRectBlock copy];
        
        [self setNeedsDisplay];
    }
}

@end

@implementation UIView (BKAdditions)

- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
{
    BKDrawRectBlockView *drawRectBlockView = [[BKDrawRectBlockView alloc] initWithDrawRectBlock:aDrawRectBlock];
    return drawRectBlockView;
}

- (void)setDrawRectBlock:(BKRectBlock)newDrawRectBlock;
{
    if ([self isKindOfClass:[BKDrawRectBlockView class]] && [self respondsToSelector:@selector(setInternalDrawRectBlock:)]) {
        [(BKDrawRectBlockView *)self setInternalDrawRectBlock:newDrawRectBlock];
    }
}

- (BKRectBlock)drawRectBlock;
{
    if ([self isKindOfClass:[BKDrawRectBlockView class]] && [self respondsToSelector:@selector(internalDrawRectBlock)]) {
        return [(BKDrawRectBlockView *)self internalDrawRectBlock];
    }
    return nil;
}

@end

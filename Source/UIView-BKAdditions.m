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
@property (nonatomic, copy) void (^internalDrawRectBlock)(CGRect dirtyRect);

- (id)initWithDrawRectBlock:(void (^) (CGRect))aDrawRectBlock;
@end

@implementation BKDrawRectBlockView

@synthesize internalDrawRectBlock;

- (id)initWithDrawRectBlock:(void (^) (CGRect))aDrawRectBlock;
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

- (void)setInternalDrawRectBlock:(void (^)(CGRect))newInternalDrawRectBlock;
{
    if (newInternalDrawRectBlock != internalDrawRectBlock) {
        [internalDrawRectBlock autorelease];
        internalDrawRectBlock = [newInternalDrawRectBlock copy];
        
        [self setNeedsDisplay];
    }
}

@end

@implementation UIView (BKAdditions)

- (id)initWithDrawRectBlock:(void (^) (CGRect))aDrawRectBlock;
{
    BKDrawRectBlockView *drawRectBlockView = [[BKDrawRectBlockView alloc] initWithDrawRectBlock:aDrawRectBlock];
    return drawRectBlockView;
}

- (void)setDrawRectBlock:(void (^) (CGRect))newDrawRectBlock;
{
    if ([self isKindOfClass:[BKDrawRectBlockView class]] && [self respondsToSelector:@selector(setInternalDrawRectBlock:)]) {
        [(BKDrawRectBlockView *)self setInternalDrawRectBlock:newDrawRectBlock];
    }
}

- (void (^) (CGRect))drawRectBlock;
{
    if ([self isKindOfClass:[BKDrawRectBlockView class]] && [self respondsToSelector:@selector(internalDrawRectBlock)]) {
        return [(BKDrawRectBlockView *)self internalDrawRectBlock];
    }
    return nil;
}

@end

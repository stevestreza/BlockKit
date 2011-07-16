//
//  BKAnimationDelegate.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 11/18/09.
//

#import "BKAnimationDelegate.h"


@implementation BKAnimationDelegate

@synthesize animation;
@synthesize key;
@synthesize view;
@synthesize completionBlock;

#pragma mark Static Methods

+ (void)startAnimation:(CAAnimation *)animation view:(UIView *)view key:(NSString *)key completionBlock:(BKVoidBlock)block;
{
    CCAnimationDelegate *delegate = [[[[self class] alloc] init] autorelease];

    delegate.animation = animation;
    delegate.view = view;
    delegate.key = key ? key : @"animation";
    delegate.completionBlock = block;

    [delegate start];
}

#pragma mark Initialization

- (void)dealloc;
{
    self.key = nil;
    self.completionBlock = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)start;
{
    if (!self.animation) {
        return;
    }

    [self retain];
    self.animation.delegate = self;
    [self.view.layer addAnimation:self.animation forKey:self.key];
}

#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)inAnimation finished:(BOOL)finished;
{
    if (completionBlock) {
        completionBlock();
        self.completionBlock = nil;
    }
    
    [self autorelease];
}

@end

//
//  UIControl-BKAdditions.m
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import "UIControl-BKAdditions.h"
#import "BKVoidBlockWrapper.h"
#import "NSObject-BKAdditions.h"


@implementation UIControl (BKAdditions)

+ (void)load;
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(dealloc) withNewSelector:@selector(bk_dealloc)];
    });
}

- (void)addActionForControlEvents:(UIControlEvents)controlEvents usingBlock:(BKVoidBlock)block;
{
    BKVoidBlockWrapper *blockWrapper = [[BKVoidBlockWrapper alloc] initWithBlock:block userInfo:[NSNumber numberWithInteger:controlEvents]];
    [self addTarget:blockWrapper action:@selector(performBlock) forControlEvents:controlEvents];
}

- (void)removeAllActionBlocks;
{
    NSArray *targets = [[self.allTargets copy] autorelease];
    
    for (id currTarget in targets) {
        if ([currTarget isKindOfClass:[BKVoidBlockWrapper class]]) {
            UIControlEvents controlEvents = [[(BKVoidBlockWrapper *)currTarget userInfo] integerValue];
            [self removeTarget:currTarget action:@selector(performBlock) forControlEvents:controlEvents];
            [currTarget release];
        }
    }
}

- (void)bk_dealloc;
{
    [self removeAllActionBlocks];
    
    [self bk_dealloc];
}

@end

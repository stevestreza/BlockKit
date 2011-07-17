//
//  UIControl-BKAdditions.m
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import "UIControl-BKAdditions.h"
#import "NSObject-BKAdditions.h"


// Private Methods
@interface BKVoidBlockWrapper : NSObject

@property (nonatomic, copy) BKVoidBlock block;
@property (nonatomic, retain) id userInfo;

- (id)initWithBlock:(BKVoidBlock)aBlock userInfo:(id)someUserInfo;
- (void)performBlock;

@end


@implementation BKVoidBlockWrapper

@synthesize block;
@synthesize userInfo;

#pragma mark Initialization

- (id)initWithBlock:(BKVoidBlock)aBlock userInfo:(id)someUserInfo;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    block = [aBlock copy];
    userInfo = [someUserInfo retain];

    return self;
}

- (void)dealloc;
{
    [block release];
    block = nil;
    [userInfo release];
    userInfo = nil;
    
    [super dealloc];
}

- (void)performBlock;
{
    if (self.block) {
        self.block();
    }
}

@end


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

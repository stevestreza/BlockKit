//
//  BKVoidBlockWrapper.m
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import "BKVoidBlockWrapper.h"


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

#pragma mark Public Methods

- (void)performBlock;
{
    if (self.block) {
        self.block();
    }
}

@end

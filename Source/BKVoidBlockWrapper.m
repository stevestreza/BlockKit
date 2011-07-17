//
//  BKVoidBlockWrapper.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
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

- (void)performBlock;
{
    if (self.block) {
        self.block();
    }
}

@end

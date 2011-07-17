//
//  NSTimer-BKAdditions.m
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import "NSTimer-BKAdditions.h"
#import "BKVoidBlockWrapper.h"


@implementation NSTimer (BKAdditions)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
{
    BKVoidBlockWrapper *wrapper = [[BKVoidBlockWrapper alloc] initWithBlock:block userInfo:nil];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:seconds target:wrapper selector:@selector(performBlock) userInfo:nil repeats:repeats];
    [wrapper release];
    return timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
{
    BKVoidBlockWrapper *wrapper = [[BKVoidBlockWrapper alloc] initWithBlock:block userInfo:nil];
    NSTimer *timer = [self timerWithTimeInterval:seconds target:wrapper selector:@selector(performBlock) userInfo:nil repeats:repeats];
    [wrapper release];
    return timer;
}

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
{
    BKVoidBlockWrapper *wrapper = [[BKVoidBlockWrapper alloc] initWithBlock:block userInfo:nil];
    NSTimer *timer = [self initWithFireDate:date interval:seconds target:wrapper selector:@selector(performBlock) userInfo:nil repeats:repeats];
    [wrapper release];
    return timer;
}

@end

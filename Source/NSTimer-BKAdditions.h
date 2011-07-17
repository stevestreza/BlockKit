//
//  NSTimer-BKAdditions.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSTimer (BKAdditions)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(BKVoidBlock)block;
                                                                                                 
@end

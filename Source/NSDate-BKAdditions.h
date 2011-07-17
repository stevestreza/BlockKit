//
//  NSDate-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//

#import "BKTypes.h"


@interface NSDate (BKAdditions)

- (void)enumerateByDayToDate:(NSDate *)endDate step:(NSInteger)step usingBlock:(BKDateBlock)block;
- (void)enumerateByHourToDate:(NSDate *)endDate step:(NSInteger)step usingBlock:(BKDateBlock)block;
- (void)enumerateByTimeInterval:(NSTimeInterval)interval endDate:(NSDate *)endDate usingBlock:(BKDateBlock)block;

@end

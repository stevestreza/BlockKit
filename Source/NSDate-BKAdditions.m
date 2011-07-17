//
//  NSDate-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//

#import "NSDate-BKAdditions.h"


@implementation NSDate (BKAdditions)

#pragma mark Public Methods

- (void)enumerateByDayToDate:(NSDate *)endDate step:(NSInteger)step usingBlock:(BKDateBlock)block;
{
    const NSTimeInterval secondsPerDay = 86400.0;
    [self enumerateByTimeInterval:secondsPerDay * (NSTimeInterval)step endDate:endDate usingBlock:block];
}

- (void)enumerateByHourToDate:(NSDate *)endDate step:(NSInteger)step usingBlock:(BKDateBlock)block;
{
    const NSTimeInterval secondsPerHour = 3600.0;
    [self enumerateByTimeInterval:secondsPerHour * (NSTimeInterval)step endDate:endDate usingBlock:block];
}

- (void)enumerateByTimeInterval:(NSTimeInterval)interval endDate:(NSDate *)endDate usingBlock:(BKDateBlock)block;
{
    // no point if there's no interval or block to call
    if ((interval == 0.0 || !block) ||
        // you can't go from a later date to an earlier date if interval is greater than 0
        (interval > 0.0 && [self compare:endDate] == NSOrderedDescending) ||
        // you can't go from an earlier date to a later date if interval is less than 0
        (interval < 0.0 && [self compare:endDate] == NSOrderedAscending)) {
        return;
    }
    
    // enumerate backwards/forwards depending on the step increment
    NSDate *currentDate = self;
    do {
        block(currentDate);
        currentDate = [currentDate dateByAddingTimeInterval:interval];
    } while ((interval > 0.0 && [currentDate compare:endDate] != NSOrderedDescending) ||
             (interval < 0.0 && [currentDate compare:endDate] != NSOrderedAscending));

}

@end

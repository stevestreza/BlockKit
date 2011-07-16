//
//  NSObject-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/13/09.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSObject (BKAdditions)

- (void)performAfterDelay:(NSTimeInterval)delay usingBlock:(BKVoidBlock)block;
- (void)performOnMainThreadUsingBlock:(BKVoidBlock)block;

@end

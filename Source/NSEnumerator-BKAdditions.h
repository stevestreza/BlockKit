//
//  NSEnumerator-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//

#import "BKTypes.h"


@interface NSEnumerator (BKAdditions)

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, BOOL *stop))block;

@end

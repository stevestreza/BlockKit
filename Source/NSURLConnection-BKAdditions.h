//
//  NSURLConnection-BKAdditions.h
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSURLConnection (BKAdditions)

- (id)initWithRequest:(NSURLRequest *)request completionBlock:(BKConnectionCompletionBlock)completionBlock;
- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(BKConnectionCompletionBlock)completionBlock;

@end

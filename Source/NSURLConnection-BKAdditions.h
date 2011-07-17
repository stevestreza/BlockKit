//
//  NSURLConnection-BKAdditions.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSURLConnection (BKAdditions)

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request completionBlock:(BKConnectionCompletionBlock)completionBlock;
- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(BKConnectionCompletionBlock)completionBlock;

- (void)startWithCompletionBlock:(BKConnectionCompletionBlock)completionBlock;

@end

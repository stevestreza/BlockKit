//
//  NSNotificationCenter-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 12/14/10.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (BKAdditions)

- (void)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue owner:(id)owner usingBlock:(void (^)(NSNotification *))block;

- (void)removeObserversWithOwner:(id)owner;
- (void)removeObserversWithOwner:(id)owner name:(NSString *)name object:(id)object;

@end

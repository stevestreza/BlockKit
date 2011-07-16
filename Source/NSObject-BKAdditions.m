//
//  NSObject-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/13/09.
//

#import "NSObject-BKAdditions.h"

static NSMutableDictionary *associationDictionary = nil;

@implementation NSObject (BKAdditions)

#pragma mark Public Methods

- (void)performAfterDelay:(NSTimeInterval)delay usingBlock:(BKVoidBlock)block;
{
    [self performSelector:@selector(_executeBlock:) withObject:[block copy] afterDelay:delay];
}

- (void)performOnMainThreadUsingBlock:(BKVoidBlock)block;
{
    [self performSelectorOnMainThread:@selector(_executeBlock:) withObject:[block copy] waitUntilDone:YES];
}

- (void *)associationKeyForPropertyName:(NSString *)propertyName;
{
    if (!associationDictionary) {
        associationDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *associationKey = [associationDictionary objectForKey:propertyName];
    if (associationKey == nil) {
        associationKey = [[propertyName copy] autorelease];
        [associationDictionary setObject:associationKey forKey:propertyName];
    }
    
    return associationKey;
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;
{
    Method origMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if (class_addMethod([self class], originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod([self class], newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

#pragma mark Private Methods

- (void)_executeBlock:(BKVoidBlock)block;
{
    if (block) {
        block();
        [block release];
    }
}

@end

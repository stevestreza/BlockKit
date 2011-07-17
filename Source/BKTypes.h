//
//  BKTypes.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//


// Types
typedef void (^BKVoidBlock)(void);
typedef void (^BKCompletionBlock)(BOOL finished);
typedef void (^BKContextBlock)(CGContextRef context);
typedef void (^BKRectBlock)(CGRect rect);
typedef id (^BKCacheBlock)();
typedef void (^BKIndexPathBlock)(NSIndexPath *indexPath);
typedef void (^BKButtonIndexBlock)(NSInteger buttonIndex);
typedef void (^BKStringBlock)(NSString *string);
typedef void (^BKUniCharBlock)(unichar character);
typedef void (^BKConnectionCompletionBlock)(NSData *responseData, NSURLResponse *urlResponse, NSError *error);
typedef void (^BKDateBlock)(NSDate *date);
typedef void (^BKViewBlock)(UIView *view);
typedef void (^BKTaskBlock)(id obj, NSDictionary *change);


// Helper Macros
#define BKBlockCat(A, B) A##B
#define BKBlockSafe(V) __block __typeof__(V) BKBlockCat(safe, V) __attribute__((unused)) = V

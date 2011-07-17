//
//  BKTypes.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//


typedef void (^BKVoidBlock)(void);
typedef void (^BKCompletionBlock)(BOOL finished);
typedef void (^BKContextBlock)(CGContextRef context);
typedef void (^BKRectBlock)(CGRect rect);
typedef id (^BKCacheBlock)();
typedef void (^BKIndexPathBlock)(NSIndexPath *indexPath);
typedef void (^BKButtonIndexBlock)(NSInteger buttonIndex);
typedef void (^BKStringBlock)(NSString *string);
typedef void (^BKCharBlock)(char character);
typedef void (^BKConnectionCompletionBlock)(NSData *responseData, NSURLResponse *urlResponse, NSError *error);

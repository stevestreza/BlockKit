//
//  BKVoidBlockWrapper.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface BKVoidBlockWrapper : NSObject

@property (nonatomic, copy) BKVoidBlock block;
@property (nonatomic, retain) id userInfo;

- (id)initWithBlock:(BKVoidBlock)aBlock userInfo:(id)someUserInfo;
- (void)performBlock;

@end

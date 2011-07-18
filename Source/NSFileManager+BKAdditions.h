//
//  NSFileManager+BKAdditions.h
//  BlockKit
//
//  Created by Steve Streza on 7/17/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"

@interface NSFileManager (BKAdditions)

-(void)getContentsAtPath:(NSString *)path handler:(BKDataReadBlock)handler;

@end

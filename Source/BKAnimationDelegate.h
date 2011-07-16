//
//  BKAnimationDelegate.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 11/18/09.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "BKTypes.h"


@interface BKAnimationDelegate : NSObject {
    UIView *view;
    CAAnimation *animation;
    NSString *key;
    BKVoidBlock completionBlock;
}

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) CAAnimation *animation;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, copy) BKVoidBlock completionBlock;

+ (void)startAnimation:(CAAnimation *)animation view:(UIView *)view key:(NSString *)key completionBlock:(BKVoidBlock)block;

- (void)start;

@end

//
//  UIImage-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/11/09.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"


@interface UIImage (BKAdditions)

+ (UIImage *)imageWithSize:(CGSize)size scale:(CGFloat)scale block:(BKContextBlock)block;

@end

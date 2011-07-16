//
//  UIAlertView-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/12/09.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"


@interface UIAlertView (BKAdditions)

- (void)showUsingButtonBlock:(BKButtonIndexBlock)block;

@end

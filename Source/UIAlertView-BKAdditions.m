//
//  UIAlertView-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/12/09.
//

#import "UIAlertView-BKAdditions.h"


// Private Classes
@interface BKAlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (nonatomic, copy) BKButtonIndexBlock buttonBlock;

@end


@implementation UIAlertView (BKAdditions)

#pragma mark Public Methods

- (void)showUsingButtonBlock:(BKButtonIndexBlock)block;
{
    BKAlertViewDelegate *alertDelegate = [[BKAlertViewDelegate alloc] init];
    alertDelegate.buttonBlock = block;
    self.delegate = alertDelegate;
    
    [self show];
}

@end


@implementation BKAlertViewDelegate

@synthesize buttonBlock;

#pragma mark Initialization

- (void)dealloc;
{
    self.buttonBlock = nil;
    
    [super dealloc];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonBlock) {
        buttonBlock(buttonIndex);
        self.buttonBlock = nil;
    }
    
    [self autorelease];
}

@end

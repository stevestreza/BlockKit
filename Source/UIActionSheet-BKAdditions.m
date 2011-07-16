//
//  UIActionSheet-CCAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 3/19/09.
//

#import "UIActionSheet-BKAdditions.h"


// Private Classes
@interface BKActionSheetDelegate : NSObject <UIActionSheetDelegate>

@property (nonatomic, copy) BKButtonIndexBlock buttonBlock;

@end


@implementation UIActionSheet (BKAdditions)

#pragma mark Public Methods

- (void)showFromView:(UIView *)view;
{
    if ([view isKindOfClass:[UITabBar class]]) {
        [self showFromTabBar:(UITabBar *)view];
    } else if ([view isKindOfClass:[UIToolbar class]]) {
        [self showFromToolbar:(UIToolbar *)view];
    } else {
        [self showInView:view];
    }
}

- (void)showFromView:(UIView *)view buttonBlock:(BKButtonIndexBlock)block;
{
    BKActionSheetDelegate *sheetDelegate = [[BKActionSheetDelegate alloc] init];
    sheetDelegate.buttonBlock = block;
    self.delegate = sheetDelegate;
    
    [self showFromView:view];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated buttonBlock:(BKButtonIndexBlock)block;
{
    BKActionSheetDelegate *sheetDelegate = [[BKActionSheetDelegate alloc] init];
    sheetDelegate.buttonBlock = block;
    self.delegate = sheetDelegate;
    
    [self showFromRect:rect inView:view animated:animated];
}

@end


@implementation BKActionSheetDelegate

@synthesize buttonBlock;

#pragma mark Initialization

- (void)dealloc;
{
    self.buttonBlock = nil;
    
    [super dealloc];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonBlock) {
        buttonBlock(buttonIndex);
        self.buttonBlock = nil;        
    }
    
    [self autorelease];
}

@end

//
//  UIView-BKAdditions.m
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import "UIView-BKAdditions.h"
#import "NSObject-BKAdditions.h"
#import "NSString-BKAdditions.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIView (BKAdditionsPrivate)
+ (Class)_createDrawRectBlockViewSubclassForClass:(Class)class;
@end


@implementation UIView (BKAdditions)

@dynamic drawRectBlock;

- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
{
    Class drawRectSubclass = [[self class] _createDrawRectBlockViewSubclassForClass:[self class]];
    
    id drawRectBlockView = [[drawRectSubclass alloc] init];
    [drawRectBlockView setDrawRectBlock:aDrawRectBlock];
    
    return drawRectBlockView;
}

#pragma mark - BKAdditionsPrivate

static void BKDrawRectBlockViewBKDrawRect(id self, SEL _cmd, CGRect dirtyRect) {
    BOOL hasDrawn = NO;
    if ([self respondsToSelector:@selector(drawRectBlock)]) {
        BKRectBlock drawRectBlock = [self drawRectBlock];
        if (drawRectBlock) {
            drawRectBlock(dirtyRect);
            hasDrawn = YES;
        }
    }
    
    if (!hasDrawn) {
        objc_msgSend(self, @selector(bk_drawRect:), dirtyRect);
    }
}


static void BKDrawRectBlockViewBKDealloc(id self, SEL _cmd) {
    if ([self respondsToSelector:@selector(setDrawRectBlock:)]) {
        [self setDrawRectBlock:nil];
    }
    
    if ([self respondsToSelector:@selector(bk_dealloc)]) {
        [self performSelector:@selector(bk_dealloc)];
    }
}


static void BKDrawRectBlockViewSetDrawRectBlock(id self, SEL _cmd, BKRectBlock drawRectBlock) {
    objc_setAssociatedObject(self, [self associationKeyForPropertyName:[NSStringFromSelector(_cmd) getterMethodString]], drawRectBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setNeedsDisplay];
}

static BKRectBlock BKDrawRectBlockViewDrawRectBlock(id self, SEL _cmd) {
    return objc_getAssociatedObject(self, [self associationKeyForPropertyName:NSStringFromSelector(_cmd)]);
}

+ (Class)_createDrawRectBlockViewSubclassForClass:(Class)class;
{
    NSString *subclassName = [@"BKDrawRect_" stringByAppendingString:NSStringFromClass(class)];
    Class drawRectSubclass = objc_allocateClassPair(class, [subclassName UTF8String], 0);
    
    
    SEL bkDeallocSelector = @selector(bk_dealloc);
    Method deallocMethod = class_getInstanceMethod(drawRectSubclass, @selector(dealloc));
    class_addMethod(drawRectSubclass, bkDeallocSelector, (IMP)BKDrawRectBlockViewBKDealloc, method_getTypeEncoding(deallocMethod));
    Method bkDeallocMethod = class_getInstanceMethod(drawRectSubclass, bkDeallocSelector);
    method_exchangeImplementations(bkDeallocMethod, deallocMethod);
    
    SEL bkDrawRectSelector = @selector(bk_drawRect:);
    Method drawRectMethod = class_getInstanceMethod(drawRectSubclass, @selector(drawRect:));
    class_addMethod(drawRectSubclass, bkDrawRectSelector, (IMP)BKDrawRectBlockViewBKDrawRect, method_getTypeEncoding(drawRectMethod));
    Method bkDrawRectMethod = class_getInstanceMethod(drawRectSubclass, bkDrawRectSelector);
    method_exchangeImplementations(drawRectMethod, bkDrawRectMethod);
    
    NSString *drawRectBlockGetterTypeEncoding = [NSString stringWithFormat: @"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    SEL drawRectBlockGetterSelector = @selector(drawRectBlock);
    if (!class_addMethod(drawRectSubclass, drawRectBlockGetterSelector, (IMP)BKDrawRectBlockViewDrawRectBlock, [drawRectBlockGetterTypeEncoding UTF8String])) {
        class_replaceMethod(drawRectSubclass, drawRectBlockGetterSelector, (IMP)BKDrawRectBlockViewDrawRectBlock, [drawRectBlockGetterTypeEncoding UTF8String]);
    }
    
    NSString *drawRectBlockSetterTypeEncoding = [NSString stringWithFormat: @"%s%s%s%s", @encode(void), @encode(id), @encode(SEL), @encode(BKRectBlock)];
    SEL drawRectBlockSetterSelector = @selector(setDrawRectBlock:);
    
    if (!class_addMethod(drawRectSubclass, drawRectBlockSetterSelector, (IMP)BKDrawRectBlockViewSetDrawRectBlock, [drawRectBlockSetterTypeEncoding UTF8String])) {
        class_replaceMethod(drawRectSubclass, drawRectBlockGetterSelector, (IMP)BKDrawRectBlockViewSetDrawRectBlock, [drawRectBlockSetterTypeEncoding UTF8String]);
    }
    
    objc_registerClassPair(drawRectSubclass);
    return drawRectSubclass;
}

@end

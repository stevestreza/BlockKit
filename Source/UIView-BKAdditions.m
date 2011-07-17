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

static void BKDrawRectBlockViewDrawRect(id self, SEL _cmd, CGRect dirtyRect) {
    BKRectBlock drawRectBlock = [self drawRectBlock];
    if (drawRectBlock) {
        drawRectBlock(dirtyRect);
    }
}


static void BKDrawRectBlockViewDealloc(id self, SEL _cmd) {
    [self setDrawRectBlock:nil];
    
    struct objc_super superStruct = { self, [self superclass] };
    objc_msgSendSuper(&superStruct, @selector(dealloc));
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
    
    SEL drawRectSelector = @selector(drawRect:);
    Method drawRectMethod = class_getInstanceMethod(drawRectSubclass, drawRectSelector);
    if (!class_addMethod(drawRectSubclass, drawRectSelector, (IMP)BKDrawRectBlockViewDrawRect, method_getTypeEncoding(drawRectMethod))) {
        class_replaceMethod(drawRectSubclass, drawRectSelector, (IMP)BKDrawRectBlockViewDrawRect, method_getTypeEncoding(drawRectMethod));
    }
    
    SEL deallocSelector = @selector(dealloc);
    Method deallocMethod = class_getInstanceMethod(drawRectSubclass, deallocSelector);
    if (!class_addMethod(drawRectSubclass, deallocSelector, (IMP)BKDrawRectBlockViewDealloc, method_getTypeEncoding(deallocMethod))) {
        class_replaceMethod(drawRectSubclass, deallocSelector, (IMP)BKDrawRectBlockViewDealloc, method_getTypeEncoding(deallocMethod));
    }
    
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

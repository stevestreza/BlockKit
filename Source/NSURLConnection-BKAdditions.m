//
//  NSURLConnection-BKAdditions.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NSURLConnection-BKAdditions.h"
#import <objc/runtime.h>
#import "NSObject-BKAdditions.h"
#import "NSString-BKAdditions.h"

@interface BKURLConnectionDelegateWrapper : NSObject
@property (nonatomic, copy) BKConnectionCompletionBlock completionBlock;
@property (nonatomic, retain) NSURLResponse *urlResponse;
@property (nonatomic, retain) NSMutableData *responseData;

- (id)initWithCompletionBlock:(BKConnectionCompletionBlock)aCompletionBlock;
@end

@implementation BKURLConnectionDelegateWrapper

@synthesize completionBlock;
@synthesize urlResponse;
@synthesize responseData;

- (id)initWithCompletionBlock:(BKConnectionCompletionBlock)aCompletionBlock;
{
    if ((self = [super init])) {
        completionBlock = [aCompletionBlock copy];
        responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc;
{
    [completionBlock release];
    completionBlock = nil;
    [urlResponse release];
    urlResponse = nil;
    [responseData release];
    responseData = nil;
    
    [super dealloc];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    self.urlResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    if (self.completionBlock) {
        self.completionBlock([NSData dataWithData:self.responseData], self.urlResponse, error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    if (self.completionBlock) {
        self.completionBlock([NSData dataWithData:self.responseData], self.urlResponse, nil);
    }
}

@end

@interface NSURLConnection (BKAdditionsPrivate)
@property (nonatomic, retain) BKURLConnectionDelegateWrapper *delegateWrapper;
@end

@implementation NSURLConnection (BKAdditions)

- (id)initWithRequest:(NSURLRequest *)request;
{
    BKURLConnectionDelegateWrapper *wrapper = [[BKURLConnectionDelegateWrapper alloc] initWithCompletionBlock:nil];
    NSURLConnection *retConnection = [self initWithRequest:request delegate:wrapper startImmediately:NO];
    retConnection.delegateWrapper = wrapper;
    [wrapper release];
    return retConnection;
}

- (id)initWithRequest:(NSURLRequest *)request completionBlock:(BKConnectionCompletionBlock)completionBlock;
{
    BKURLConnectionDelegateWrapper *wrapper = [[BKURLConnectionDelegateWrapper alloc] initWithCompletionBlock:completionBlock];
    NSURLConnection *retConnection = [self initWithRequest:request delegate:wrapper];
    retConnection.delegateWrapper = wrapper;
    [wrapper release];
    return retConnection;
}

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(BKConnectionCompletionBlock)completionBlock;
{
    BKURLConnectionDelegateWrapper *wrapper = [[BKURLConnectionDelegateWrapper alloc] initWithCompletionBlock:completionBlock];
    NSURLConnection *retConnection = [self initWithRequest:request delegate:wrapper startImmediately:startImmediately];
    retConnection.delegateWrapper = wrapper;
    [wrapper release];
    return retConnection;
}

- (void)startWithCompletionBlock:(BKConnectionCompletionBlock)completionBlock;
{
    self.delegateWrapper.completionBlock = completionBlock;
    
    [self start];
}

- (BKURLConnectionDelegateWrapper *)delegateWrapper;
{
    return objc_getAssociatedObject(self, [self associationKeyForPropertyName:NSStringFromSelector(_cmd)]);
}

- (void)setDelegateWrapper:(BKURLConnectionDelegateWrapper *)newDelegateWrapper;
{
    objc_setAssociatedObject(self, [self associationKeyForPropertyName:[NSStringFromSelector(_cmd) getterMethodString]], newDelegateWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

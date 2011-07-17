//
//  NSURLConnection-BKAdditions.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NSURLConnection-BKAdditions.h"


// Private Classes
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

#pragma mark Initialization

- (id)initWithCompletionBlock:(BKConnectionCompletionBlock)aCompletionBlock;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    completionBlock = [aCompletionBlock copy];
    responseData = [[NSMutableData alloc] init];

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

#pragma mark NSURLConnectionDelegate

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
    if (completionBlock) {
        self.completionBlock([NSData dataWithData:self.responseData], self.urlResponse, error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    if (completionBlock) {
        self.completionBlock([NSData dataWithData:self.responseData], self.urlResponse, nil);
    }
}

@end


@implementation NSURLConnection (BKAdditions)

- (id)initWithRequest:(NSURLRequest *)request completionBlock:(BKConnectionCompletionBlock)completionBlock;
{
    BKURLConnectionDelegateWrapper *wrapper = [[BKURLConnectionDelegateWrapper alloc] initWithCompletionBlock:completionBlock];
    id retConnection = [self initWithRequest:request delegate:wrapper];
    [wrapper release];
    return retConnection;
}

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(BKConnectionCompletionBlock)completionBlock;
{
    BKURLConnectionDelegateWrapper *wrapper = [[BKURLConnectionDelegateWrapper alloc] initWithCompletionBlock:completionBlock];
    id retConnection = [self initWithRequest:request delegate:wrapper startImmediately:startImmediately];
    [wrapper release];
    return retConnection;
}

@end

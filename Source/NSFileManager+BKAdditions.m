//
//  NSFileManager+BKAdditions.h
//  BlockKit
//
//  Created by Steve Streza on 7/17/11.
//

#import "NSFileManager+BKAdditions.h"
#import <dispatch/dispatch.h>
#import <sys/fcntl.h>

#define DISPATCH_GET_DEFAULT_GLOBAL_QUEUE() dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation NSFileManager (BKAdditions)

-(void)getContentsAtPath:(NSString *)path handler:(BKDataReadBlock)handler{
	dispatch_queue_t queue = DISPATCH_GET_DEFAULT_GLOBAL_QUEUE();
	dispatch_async(queue, ^{
		int fd = open([path cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY | O_NONBLOCK);
		if(fd < 1){
			handler(nil, [NSError errorWithDomain:NSPOSIXErrorDomain code:fd userInfo:nil]);
			return;
		}
		
		NSMutableData *data = [[NSMutableData data] retain];
		
		// create a GCD source using the file descriptor, which will respond whenever the descriptor fires
		dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, queue);
		
		BKVoidBlock cleanup = ^{
			[data release];
			dispatch_source_cancel(source);
			dispatch_release(source);
			close(fd);
		};
		
		dispatch_source_set_event_handler(source, ^{
			BOOL eof = NO;
            
			// if we get less than this much, we hit end of file, so we can file the callback
			NSUInteger max = 65536;
			void *buf = malloc((max+1) * sizeof(char));
			int readLength = read(fd, buf, max);
			if(readLength < 0){
 				handler(nil, [NSError errorWithDomain:NSPOSIXErrorDomain code:readLength userInfo:nil]);				
				cleanup();
				return;
			}
			if(readLength == 0 || readLength < max) eof = YES;
			
			[data appendBytes:buf length:readLength];
			
			free(buf);
			buf = NULL;
            
			if(eof){
				dispatch_async(dispatch_get_main_queue(), ^{
					handler([[data retain] autorelease], nil);
				});
				
				cleanup();
			}
		});
		dispatch_resume(source);
	});
}

@end

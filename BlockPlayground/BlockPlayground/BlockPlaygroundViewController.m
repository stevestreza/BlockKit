//
//  BlockPlaygroundViewController.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "BlockPlaygroundViewController.h"
#import "BKTestView.h"
#import "UIView-BKAdditions.h"
#import "UIControl-BKAdditions.h"
#import "NSURLConnection-BKAdditions.h"
#import "NSString-BKAdditions.h"

@implementation BlockPlaygroundViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BKBlockSafe(self);
    
    BKTestView *blockView = [[BKTestView alloc] initWithFrame:self.view.frame drawRectBlock:^(CGRect dirtyRect) {
        NSLog(@"Some draw rect");
    }];
    
    blockView.frame = self.view.frame;
    self.view = blockView;
    
    [blockView release];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    greenView.backgroundColor = [UIColor greenColor];
    
    self.view.drawRectBlock = ^(CGRect dirtyRect) {
        [[UIColor redColor] set];
        [[UIBezierPath bezierPathWithRect:safeself.view.bounds] fill]; 
    };
    
    self.view.layoutSubviewsBlock = ^{
        BKCenterViewInSuperviewBlock(greenView);
    };
    
    [self.view addSubview:greenView];
    
    
    /* NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com/"]];
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request];
     
     [connection startWithCompletionBlock:^(NSData *responseData, NSURLResponse *urlResponse, NSError *error) {
     if (!error) {
     NSLog(@"Response String: %@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
     } else {
     NSLog(@"Response Error: %@", error);
     }
     }];
     
     [connection release]; */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

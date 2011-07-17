//
//  BlockPlaygroundAppDelegate.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "BlockPlaygroundAppDelegate.h"
#import "BlockPlaygroundViewController.h"
#import "NSArray-BKAdditions.h"


@implementation BlockPlaygroundAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // some tests
    NSLog(@"iterate from 5 to 10");
    [NSArray iterateFrom:5 upTo:10 usingBlock:^(NSInteger value) {
        NSLog(@"num: %d", value);
    }];
    
    NSLog(@"iterate from 10 down to 5");
    [NSArray iterateFrom:10 downTo:5 usingBlock:^(NSInteger value) {
        NSLog(@"num: %d", value);
    }];
    
    NSLog(@"iterate 5 times");
    [NSArray iterateTimes:5 usingBlock:^(NSUInteger value) {
        NSLog(@"num: %d", value);
    }];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[BlockPlaygroundViewController alloc] initWithNibName:@"BlockPlaygroundViewController" bundle:nil]; 
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

//
//  ESAppDelegate.m
//  transponder
//
//  Created by Alonso Holmes on 4/1/14.
//  Copyright (c) 2014 mtnlab. All rights reserved.
//

#import "ESAppDelegate.h"

@implementation ESAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Initialize the transponder. Users will not yet be asked for Bluetooth and Location permissions.
    self.transponder = [ESTransponder sharedInstance];
    
    // Grab the ID, to associate with your own users.
    self.transponderID = self.transponder.transponderID;
    NSLog(@"Transponder initialized. This device has ID %@", self.transponderID);
    
    // Listen for users-in-range updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUsers:) name:TransponderDidUpdateUsersInRange object:nil];
    
    // Listen for discovery notification suggestions. You can also listen to `TransponderUserDiscovered` and `TransponderAnonymousUserDiscovered` and roll your own time-and location filtering.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendDiscoverNotification) name:TransponderSuggestsDiscoveryNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverAnonymousUser) name:TransponderAnonymousUserDiscovered object:nil];
    
    // Start the transponder broadcasting and receiving. Users will be asked for permissions at this point, if they haven't already accepted them.
    [self.transponder startTransponder];
    
    return YES;
}

- (void)updateUsers:(NSNotification *)note
{
    // Users are returned in an array
    NSArray *transponderUsers = [note.userInfo objectForKey:@"transponderUsers"];
    NSLog(@"Users in range updated: %@", transponderUsers);
    
    if ([transponderUsers count] == 0) {
        // Badge the app icon
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)didDiscoverAnonymousUser
{
    NSLog(@"Discovered anonymous user");
    NSLog(@"ok");
    
    // Badge the app icon
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
}

- (void)sendDiscoverNotification
{
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = [NSString stringWithFormat:@"Transponder users nearby!"];
    notice.alertAction = @"Converse";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notice];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appWillEnterBackground" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appWillEnterForeground" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

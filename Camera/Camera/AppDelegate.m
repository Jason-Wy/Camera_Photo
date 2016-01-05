//
//  AppDelegate.m
//  Camera
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 Woddon. All rights reserved.
//

#import "AppDelegate.h"

#define IPHONE_THREE_INCH 0
#define IPHONE_FOUR_INCH 1
#define IPAD 2

int deviceTypeId;
float screenWidth,screenHeight;

bool isiPad()
{
    
    return (deviceTypeId == IPAD);
}

bool isiPhoneFourInch()
{
    return (deviceTypeId == IPHONE_FOUR_INCH);
}



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight > screenWidth)
    {
        CGFloat temp = screenHeight;
        screenHeight = screenWidth;
        screenWidth = temp;
    }
    
    if (screenWidth == 1024.0f)
    {
        deviceTypeId = IPAD;
    }
    else if (screenWidth == 568.0f)
    {
        deviceTypeId = IPHONE_FOUR_INCH;
    }
    else
    {
        deviceTypeId = IPHONE_THREE_INCH;
    }

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

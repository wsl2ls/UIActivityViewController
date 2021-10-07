//
//  AppDelegate.m
//  UIActivityViewController
//
//  Created by 王双龙 on 16/8/30.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //第三方应用打开本应用启动
    if(launchOptions[UIApplicationLaunchOptionsURLKey] != nil){
        [self application:application handleOpenURL:launchOptions[UIApplicationLaunchOptionsURLKey]];
    }
    NSLog(@"这是一个自定义的弹框");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 iOS 9.0 以下 程序运行过程中调用
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL host:%@", [url host]);
    return YES;
}

/**
 iOS 9.0 之后 程序运行过程中调用
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
    NSLog(@"URL scheme:%@", [url scheme]);
    //参数
    NSLog(@"URL host:%@", [url host]);
    
    NSString * message;
    if ([[url host] isEqualToString:@"success"]) {
        message = @"分享成功";
    }else{
        message = @"分享失败";
    }
    
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:[url host] delegate:self cancelButtonTitle:nil otherButtonTitles:message, nil];
    [alertView show];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

@end

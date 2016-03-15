//
//  AppDelegate.m
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ConnectionManager.h"
#import "AppUtils.h"


@interface AppDelegate () <ConnectionManagerDelegate>
{
    NSString *token;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:53/255.0 green:201/255.0 blue:147/255.0 alpha:1]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - push notificaiton


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handlerNotification:application didWithData:userInfo];
}

-(void)handlerNotification:(UIApplication *)application didWithData:(NSDictionary *)userInfo{
    // For swipe or tap the notification
    application.applicationIconBadgeNumber = 0;
//    [ShareObject shareObjectManager].jsonNotification = userInfo[@"aps"];
//    [[NSNotificationCenter defaultCenter]  postNotificationName:@"notification" object:nil userInfo:nil];
    NSLog(@"======> notification : %@",userInfo[@"aps"]);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    token = [[[[deviceToken description]
               stringByReplacingOccurrencesOfString: @"<" withString: @""]
              stringByReplacingOccurrencesOfString: @">" withString: @""]
             stringByReplacingOccurrencesOfString: @" " withString: @""];
    [self registerDeviceTokens:@"KF_CHECKTOKEN" withDeviceToken:token];
}

-(void)registerDeviceTokens:(NSString *)apiKey withDeviceToken:(NSString *)deviceToken {
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:apiKey forKey:@"API_KEY"];
    
    if ([apiKey isEqualToString:@"KF_CHECKTOKEN"]) {
        [reqDic setObject:deviceToken forKey:@"TOKEN_NUMBER"];
    } else if ([apiKey isEqualToString:@"KF_REGTOKEN"]) {
        [reqDic setObject:deviceToken forKey:@"DEVICE_ID"];
        [reqDic setObject:@"" forKey:@"USER_ID"];
        [reqDic setObject:@"IOS" forKey:@"DEVICE_TYPE"];
        [reqDic setObject:[AppUtils getDeviceType] forKey:@"PHN_MODEL"];
    }
    
    ConnectionManager *con = [[ConnectionManager alloc] init];
    con.delegate = self;
    [con sendTranData:reqDic];
}

//return result
-(void)returnResultWithData:(NSData *)data {
    if (![AppUtils isNull:data]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([[dic objectForKey:@"API_KEY"] isEqualToString:@"KF_CHECKTOKEN"]) { // check existed device token
            if ([[dic objectForKey:@"STATUS"] integerValue] == 1) { // don't have
                [self registerDeviceTokens:@"KF_REGTOKEN" withDeviceToken:token];
            }
        } else if ([[dic objectForKey:@"API_KEY"] isEqualToString:@"KF_REGTOKEN"]) {
            if ([[dic objectForKey:@"STATUS"] integerValue] == 1) { // register successully
                NSLog(@"kikilu ====> OK");
            }
        }
    }
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "come.khmerfood.dobut.KhmerFood" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KhmerFood" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KhmerFood.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end

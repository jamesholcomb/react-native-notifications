#import "RNCommandsHandler.h"
#import "RNNotifications.h"
#import "RNNotificationsStore.h"
#import "RCTConvert+RNNotifications.h"

@implementation RNCommandsHandler {
    RNNotificationCenter* _notificationCenter;
}

- (instancetype)init {
    self = [super init];
    _notificationCenter = [RNNotificationCenter new];
    return self;
}

- (void)requestPermissions:(NSDictionary *)options {
    [_notificationCenter requestPermissions:options];
}

- (void)setCategories:(NSArray *)categories {
    [_notificationCenter setCategories:categories];
}

- (void)getInitialNotification:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  NSDictionary* initialNotification = [[RNNotificationsStore sharedInstance] initialNotification];
  [[RNNotificationsStore sharedInstance] setInitialNotification:nil];
  resolve(initialNotification);
}


- (void)getInitialAction:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  NSDictionary* initialAction = [[RNNotificationsStore sharedInstance] initialAction];
  [[RNNotificationsStore sharedInstance] setInitialAction:nil];
  resolve(initialAction);
}


- (void)finishHandlingAction:(NSString *)completionKey {
    [[RNNotificationsStore sharedInstance] completeAction:completionKey];
}

- (void)finishPresentingNotification:(NSString *)completionKey presentingOptions:(NSDictionary *)presentingOptions {
    [[RNNotificationsStore sharedInstance] completePresentation:completionKey withPresentationOptions:[RCTConvert UNNotificationPresentationOptions:presentingOptions]];
}

- (void)finishHandlingBackgroundAction:(NSString *)completionKey backgroundFetchResult:(NSString *)backgroundFetchResult {
    [[RNNotificationsStore sharedInstance] completeBackgroundAction:completionKey withBackgroundFetchResult:[RCTConvert UIBackgroundFetchResult:backgroundFetchResult]];
}

- (void)abandonPermissions {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)registerPushKit {
    [RNNotifications startMonitorPushKitNotifications];
}

- (void)getBadgeCount:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSInteger count = [UIApplication sharedApplication].applicationIconBadgeNumber;
    resolve([NSNumber numberWithInteger:count]);
}

- (void)setBadgeCount:(int)count {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    });
}

- (void)postLocalNotification:(NSDictionary *)notification withId:(NSNumber *)notificationId {
    [_notificationCenter postLocalNotification:notification withId:notificationId];
}

- (void)cancelLocalNotification:(NSNumber *)notificationId {
    [_notificationCenter cancelLocalNotification:notificationId];
}

- (void)cancelAllLocalNotifications {
    [_notificationCenter cancelAllLocalNotifications];
}

- (void)isRegisteredForRemoteNotifications:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_notificationCenter isRegisteredForRemoteNotifications:resolve];
}

- (void)checkPermissions:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_notificationCenter checkPermissions:resolve];
}

- (void)removeAllDeliveredNotifications {
    [_notificationCenter removeAllDeliveredNotifications];
}

- (void)removeDeliveredNotifications:(NSArray<NSString *> *)identifiers {
    [_notificationCenter removeDeliveredNotifications:identifiers];
}

- (void)getDeliveredNotifications:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_notificationCenter getDeliveredNotifications:resolve];
}

@end

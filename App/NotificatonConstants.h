static NSString * const NotificationDomain = @"com.777_hack.notification";

#define ScopeNotification(notificationString) \
  [NSString stringWithFormat:@"%@.%@",NotificationDomain,notificationString]

#define HackerHealthDidChangeNotification \
  ScopeNotification(@"hacker.health.didChange")

#define HackerWillEnterWarpZone \
  ScopeNotification(@"hacker.willEnter.warpZone")

#define HackerDidEnterWarpZone \
  ScopeNotification(@"hacker.didEnter.warpZone")

#define HackerDidMove \
  ScopeNotification(@"hacker.didMove")
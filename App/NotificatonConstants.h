static NSString * const NotificationDomain = @"com.777_hack.notification";

#define ScopeNotification(notificationString) \
  [NSString stringWithFormat:@"%@.%@",NotificationDomain,notificationString]

#define HackerHealthDidChangeNotification \
  ScopeNotification(@"hacker.health.didChange")
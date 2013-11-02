#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
  [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [self.window setBackgroundColor:[UIColor whiteColor]];
  [self.window setRootViewController:[[ViewController alloc] init]];
  [self.window makeKeyAndVisible];
  return YES;
}
							
@end
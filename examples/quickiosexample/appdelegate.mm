#import "UIKit/UIKit.h"
#include <QtCore>

@interface QIOSApplicationDelegate
@end

@interface QIOSApplicationDelegate(AppDelegate)
@end

@implementation QIOSApplicationDelegate (AppDelegate)

// It just demonstrate how to override QIOSApplicationDelegate to get
// launch options via didFinishLaunchingWithOptions.
// QuickIOS won't support this code since it may conflict with
// other framework whose need this piece of information

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Q_UNUSED(application);

    NSLog(@"didFinishLaunchingWithOptions: %@", [launchOptions description]);

    return YES;
}

@end




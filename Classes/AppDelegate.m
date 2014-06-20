

#import "AppDelegate.h"
#import "PhotoViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [window setBackgroundColor:[UIColor whiteColor]];
    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

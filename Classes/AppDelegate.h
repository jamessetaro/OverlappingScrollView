
#import <UIKit/UIKit.h>

@class PhotoViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PhotoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PhotoViewController *viewController;

@end


#import "Headers.h"

// Auto clear cache
%hook YTAppDelegate
%new
- (void)YouModAutoClearCache {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (!cachePath) return;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachePath error:&error];
    if (!error && contents) {
        for (NSString *item in contents) {
            NSString *itemPath = [cachePath stringByAppendingPathComponent:item];
            [fileManager removeItemAtPath:itemPath error:nil];
        }
    }
}
- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions {
    BOOL result = %orig;
    if (IS_ENABLED(AutoClearCache)) {
        // Clear cache on app launch
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self YouModAutoClearCache];
        });
    }
    return result;
}
%end
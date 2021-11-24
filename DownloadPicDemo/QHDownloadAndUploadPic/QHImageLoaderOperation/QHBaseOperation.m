//
//  QHBaseOperation.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/20.
//

#import "QHBaseOperation.h"

@implementation QHBaseOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.backgroundSupport = YES;
        [self initSession];
    }
    return self;
}

- (void)initSession {
   
    if (!self.session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15;
        configuration.allowsCellularAccess = YES;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        self.session = session;
    }
}
- (void)start{
   
    if (self.isCancelled){
        self.executing = NO;
        self.finished = YES;
        return;
    }
    
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    
    if (hasApplication && self.backgroundSupport) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof (wself) sself = wself;

            if (sself) {
                [sself cancel];
                [app endBackgroundTask:sself.backgroundTaskId];
                sself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        }];
    }
    
    [self startTask];
}

- (void)startTask {}

- (void)setExecuting:(BOOL )executing{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting{
    return _executing;
}

- (void)done {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
    
    self.finished = YES;
    self.executing = NO;
}

- (void)cancel {
    @synchronized (self) {
        [self cancelLoad];
    }
}

- (void)cancelLoad {
   
    if (self.isFinished) return;
    
    [super cancel];
    [self cancelTask];
    
    if (self.session) {
        [self.session invalidateAndCancel];
        self.session = nil;
    }
}

- (void)setFinished:(BOOL )finished{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished{
    return _finished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)cancelTask{}

- (void)dealloc{
    NSLog(@"任务释放了:::");
}

@end

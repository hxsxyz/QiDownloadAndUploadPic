//
//  QHUploadPicToServeManager.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/17.
//

#import "QHUploadPicToServeManager.h"
#import "QHUploadOperation.h"

@interface QHUploadPicToServeManager()

@property (strong, nonatomic, nonnull) NSOperationQueue  *uploadQueue;
@property (strong, nonatomic, nonnull) NSMutableArray    *imageUrlList;//服务返回的图片url数组

@end

@implementation QHUploadPicToServeManager

/**
 * @brief 获取单例
 */
+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
   
    if (self) {
        self.maxConcurrentUploadCount = 3;
        self.backgroundUploadSupport = YES;
        self.uploadQueue = [[NSOperationQueue alloc] init];
        self.imageUrlList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

/**
 * @brief 上传图片到服务端
 */
- (void)uploadImageWithServeIp:(NSString *)serveIp andServeFileParameter:(NSString *)serveFileParameter andImagePathList:(NSArray *)imagePathList withCompletionHandler:(QHLoadCompletionHandler)completionHandler {
    __weak __typeof__ (self) wself = self;

    self.uploadQueue.maxConcurrentOperationCount = self.maxConcurrentUploadCount;
    [self.imageUrlList removeAllObjects];
    
    NSBlockOperation *finalTask = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"所有图片上传成功");
        __strong __typeof (wself) sself = wself;
        [sself allImageUploadComplate:completionHandler];
    }];

    for (NSInteger i = 0; i < imagePathList.count; i++) {
        QHUploadOperation *task = [[QHUploadOperation alloc] initWithServeIp:serveIp andServeFileParameter:serveFileParameter andImageUrlStr:imagePathList[i] backgroundSupport:self.backgroundUploadSupport withCompletionHandler:^(BOOL success,NSString * _Nullable imageUrl, NSError * _Nullable error) {
            __strong __typeof (wself) sself = wself;

            if (success && imageUrl) {
                [sself.imageUrlList addObject:imageUrl];
            } else {
                [sself.imageUrlList addObject:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
        }];
        [self.uploadQueue addOperation:task];
        [finalTask addDependency:task];
    }
    [self.uploadQueue addOperation:finalTask];
}

- (void)allImageUploadComplate:(QHLoadCompletionHandler)completionHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (completionHandler) {
            completionHandler(YES,self.imageUrlList);
        }
    });
}
/**
 * 取消所有上传任务
 */
- (void)cancelAllUpload {
   
    if (self.uploadQueue) {
        [self.uploadQueue cancelAllOperations];
    }
}

@end

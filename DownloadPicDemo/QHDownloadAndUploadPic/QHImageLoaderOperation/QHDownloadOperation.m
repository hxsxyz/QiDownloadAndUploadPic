//
//  QHDownloadOperation.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/10/21.
//

#import "QHDownloadOperation.h"

@interface QHDownloadOperation()

@property (copy, nonatomic, nullable) NSString *imageUrlStr;
@property (copy, nonatomic, nullable) NSURLSessionDownloadTask *downloadTask;
@property (copy, nonatomic, nullable) QHDownloadCompletionHandler completionHandler;

@end

@implementation QHDownloadOperation

- (instancetype)initWithImageUrlStr:(NSString *)imageUrlStr backgroundSupport:(BOOL)background withCompletionHandler:(QHDownloadCompletionHandler)completionHandler{
   
    if (self = [super init]) {
        self.backgroundSupport = background;
        self.imageUrlStr = imageUrlStr;
       
        if (completionHandler) {
            self.completionHandler = completionHandler;
        }
    }
    return  self;
}

- (void)startTask {
    [super startTask];
    
    __weak typeof(self) weakSelf = self;

    NSURL *url = [NSURL URLWithString:self.imageUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.downloadTask = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  lastObject];
            NSString *filePath = [cache stringByAppendingPathComponent:response.suggestedFilename];
            NSLog(@"filePath = %@",filePath);
            NSURL *toURL = [NSURL fileURLWithPath:filePath];
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:toURL error:nil];
            weakSelf.completionHandler(YES, filePath, nil);
        } else {
            weakSelf.completionHandler(NO, nil, error);
        }
        [weakSelf done];
    }];
    
    self.executing = YES;

    if (self.downloadTask) {
        [self.downloadTask resume];
    } else {
        self.completionHandler(NO, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:@{NSLocalizedDescriptionKey : @"Task can't be initialized"}]);
        [self done];
        return;
    }
}

/**
 *@brief 取消当前下载任务
 */
- (void)cancelDownLoad {
    [super cancel];
}

- (void)cancelTask {
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
        [self done];
    }
}

@end

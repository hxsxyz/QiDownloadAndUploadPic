//
//  QHUploadPicToServeManager.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QHLoadCompletionHandler)(BOOL success , NSArray *imageUrlList);

@interface QHUploadPicToServeManager : NSObject

/**
 * 网络图片最大同时上传数量
 * default = 3
 */
@property (nonatomic, assign) NSInteger maxConcurrentUploadCount;

/**
 * 是否需要后台上传网络图片
 * default = YES
 */
@property (nonatomic, assign) BOOL backgroundUploadSupport;

/**
 * @brief 获取单例
 */
+ (nonnull instancetype)sharedInstance;

/**
 * @brief 上传图片到服务端
 * @param serveIp 上传服务地址
 * @param serveFileParameter 服务端文件参数字段
 * @param imagePathList 图片路径list
 * @param completionHandler 完成后回调
 */
- (void)uploadImageWithServeIp:(NSString *)serveIp andServeFileParameter:(NSString *)serveFileParameter andImagePathList:(NSArray *)imagePathList withCompletionHandler:(QHLoadCompletionHandler)completionHandler;

/**
 * 取消所有上传任务
 */
- (void)cancelAllUpload;

@end

NS_ASSUME_NONNULL_END

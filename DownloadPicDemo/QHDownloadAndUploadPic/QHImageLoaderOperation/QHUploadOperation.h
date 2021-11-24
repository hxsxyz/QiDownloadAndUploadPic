//
//  QHUploadOperation.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/17.
//

#import <Foundation/Foundation.h>
#import "QHBaseOperation.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^QHUploadCompletionHandler)(BOOL success, NSString * __nullable imageUrl, NSError * __nullable error);

@interface QHUploadOperation : QHBaseOperation

/**
 * @brief 初始化上传任务
 * @param imageLocalUrl 图片本地地址
 * @param background 是否支持后台上传
 * @param completionHandler 上传完成后回调
 */
- (instancetype)initWithServeIp:(NSString *)serveIp andServeFileParameter:(NSString *)serveFileParameter andImageUrlStr:(NSString *)imageLocalUrl backgroundSupport:(BOOL)background withCompletionHandler:(QHUploadCompletionHandler)completionHandler;

/**
 *@brief 取消当前任务
 */
- (void)cancelUpLoad;

@end

NS_ASSUME_NONNULL_END

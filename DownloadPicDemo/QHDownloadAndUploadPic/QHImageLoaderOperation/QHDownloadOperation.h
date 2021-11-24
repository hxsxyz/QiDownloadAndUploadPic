//
//  QHDownloadOperation.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import "QHBaseOperation.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^QHDownloadCompletionHandler)(BOOL success , NSString * __nullable filePath, NSError * __nullable error);

@interface QHDownloadOperation : QHBaseOperation

/**
 * @brief 初始化下载任务
 * @param imageUrlStr 图片url
 * @param background 是否支持后台下载
 * @param completionHandler 下载完成后回调
 */
- (instancetype)initWithImageUrlStr:(NSString *)imageUrlStr backgroundSupport:(BOOL)background withCompletionHandler:(QHDownloadCompletionHandler)completionHandler;

/**
 *@brief 取消当前下载任务
 */
- (void)cancelDownLoad;
@end

NS_ASSUME_NONNULL_END

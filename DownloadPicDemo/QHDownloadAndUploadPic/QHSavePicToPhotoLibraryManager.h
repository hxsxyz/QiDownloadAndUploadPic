//
//  QHSavePicToPhotoLibraryManager.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/10/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QHSaveCompletionHandler)(BOOL success);

@interface QHSavePicToPhotoLibraryManager : NSObject

/**
 * 网络图片最大同时下载数量
 * default = 5
 */
@property (nonatomic, assign) NSInteger maxConcurrentDownloadCount;

/**
 * 保存成功后是否删除下载缓存的网络图片
 * default = YES
 */
@property (nonatomic, assign) BOOL deleteDownloadImageCache;

/**
 * 是否需要后台下载网络图片
 * default = YES
 */
@property (nonatomic, assign) BOOL backgroundDownloadSupport;

/**
 * @brief 获取单例
 */
+ (nonnull instancetype)sharedInstance;

/**
 * @brief 保存本地图片到相册
 * @param imageList 图片数组
 * @param libryName 相册名称，传空则保存到系统相册
 * @param completionHandler 保存后回调
 */
- (void)saveImageToPhotoLibraryWithImageList:(NSArray <UIImage *> *)imageList andLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler;

/**
 * @brief 下载网络图片到相册
 * @param imageUrlList 图片url数组
 * @param libryName 相册名称，传空则保存到系统相册
 * @param completionHandler 保存后回调
 */
- (void)saveOnLineImageToPhotoLibraryWithImageList:(NSArray <NSString *> *)imageUrlList andLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler;

/**
 * 取消所有下载任务
 */
- (void)cancelAllDownloads;
@end

NS_ASSUME_NONNULL_END

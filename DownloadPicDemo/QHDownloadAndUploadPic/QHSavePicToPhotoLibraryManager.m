//
//  QHSavePicToPhotoLibraryManager.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/10/25.
//

#import "QHSavePicToPhotoLibraryManager.h"
#import "QHDownloadOperation.h"
#import <Photos/Photos.h>


@interface QHSavePicToPhotoLibraryManager ()

@property (strong, nonatomic, nonnull) PHAssetCollection *createCollection;//自定义相册
@property (strong, nonatomic, nonnull) NSMutableArray    *imagePathList;
@property (strong, nonatomic, nonnull) NSOperationQueue  *downloadQueue;

@end

@implementation QHSavePicToPhotoLibraryManager

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
        self.maxConcurrentDownloadCount = 5;
        self.deleteDownloadImageCache = YES;
        self.backgroundDownloadSupport = YES;
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.imagePathList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

/**
 * @brief 保存图片到相册
 * @param imageList 图片数组
 * @param libryName 相册名称，默认为应用名
 * @param completionHandler 保存后回调
 */
- (void)saveImageToPhotoLibraryWithImageList:(NSArray <UIImage *> *)imageList andLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler {

    return [self saveImageToPhotoWithRequestAuthorizationWithImageList:imageList andLibraryNmae:libryName whetherOnLine:NO callBack:completionHandler];
}

/**
 * @brief 保存网络图片到相册
 * @param imageUrlList 图片url数组
 * @param libryName 相册名称，默认为应用名
 * @param completionHandler 保存后回调
 */
- (void)saveOnLineImageToPhotoLibraryWithImageList:(NSArray <NSString *> *)imageUrlList andLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler {
   
    return [self saveImageToPhotoWithRequestAuthorizationWithImageList:imageUrlList andLibraryNmae:libryName whetherOnLine:YES callBack:completionHandler];
}

/**
 * 后台保存任务
 */
- (void)backgroundSaveImageAndDeleteOldFilesWithLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler {
    __weak __typeof__ (self) wself = self;

    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

    NSMutableArray *cacheImageList = [NSMutableArray array];
    [self.imagePathList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = (NSString*)obj;
        [cacheImageList addObject:[UIImage imageWithContentsOfFile:filePath]];
    }];
    
    [self saveImageToPhotoLibraryWithImageList:cacheImageList andLibraryName:libryName callBack:^(BOOL success) {
        NSLog(@"所有图片存储成功");
        [cacheImageList removeAllObjects];
        [wself saveSuccessImageWithCompletionHandler:completionHandler];
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark - authorization

- (void)saveImageToPhotoWithRequestAuthorizationWithImageList:(NSArray *)imageList andLibraryNmae:(NSString *)libryName whetherOnLine:(BOOL)onLine callBack:(QHSaveCompletionHandler)completionHandler{
    __weak __typeof__ (self) wself = self;

    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        [PHPhotoLibrary requestAuthorizationForAccessLevel:level handler:^(PHAuthorizationStatus status) {
            switch (status) {
              case PHAuthorizationStatusLimited:
                    NSLog(@"受限的访问权限创建自定义相册会失败");
                    [wself executeMethodWithImageList:imageList andLibraryNmae:libryName whetherOnLine:onLine callBack:completionHandler];
                    break;
              case PHAuthorizationStatusDenied:
                    NSLog(@"访问相册权限受限");
                    [wself saveFailImageWithCompletionHandler:completionHandler];
                    break;
              case PHAuthorizationStatusAuthorized:
                    [wself executeMethodWithImageList:imageList andLibraryNmae:libryName whetherOnLine:onLine callBack:completionHandler];
                    break;
              default:
                  break;
          }
        }];
    } else {
        PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
        switch (authorStatus) {
            case PHAuthorizationStatusNotDetermined:
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [wself executeMethodWithImageList:imageList andLibraryNmae:libryName whetherOnLine:onLine callBack:completionHandler];
                    } else {
                        NSLog(@"访问相册权限受限");
                        [wself saveFailImageWithCompletionHandler:completionHandler];
                    }
                }];
            }
                break;
            case PHAuthorizationStatusAuthorized:
                [wself executeMethodWithImageList:imageList andLibraryNmae:libryName whetherOnLine:onLine callBack:completionHandler];
                break;
            default:
                NSLog(@"访问相册权限受限");
                [self saveFailImageWithCompletionHandler:completionHandler];
                break;
        }
    }
}

- (void)executeMethodWithImageList:(NSArray *)imageList andLibraryNmae:(NSString *)libryName whetherOnLine:(BOOL)onLine callBack:(QHSaveCompletionHandler)completionHandler {
    
    if (onLine) {
        [self saveOnLineImageWithAuthorizationToPhotoLibraryWithImageList:imageList andLibraryName:libryName callBack:completionHandler];
    }else {
        [self saveImageListToLibrary:[imageList mutableCopy] andLibraryNmae:libryName andSaveCallBack:completionHandler];
    }
}

- (void)saveImageListToLibrary:(NSMutableArray <UIImage *> *)imageList andLibraryNmae:(NSString *)libryName andSaveCallBack:(QHSaveCompletionHandler)completionHandler{
    __weak __typeof__ (self) wself = self;

    if ([imageList count] == 0){
    
        if (completionHandler) {
            completionHandler(YES);
        }
        return;
    }
    
    if (libryName != nil && ![libryName isEqualToString:@""]) {
        self.createCollection = [self createPHAssetLibraryWithName:libryName];
    }

    UIImage* imagePhoto = [imageList firstObject];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest;
        
        if (wself.createCollection) {
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.createCollection];
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:imagePhoto];
            PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
            [assetCollectionChangeRequest addAssets:@[placeholder]];
        } else {
            [PHAssetChangeRequest creationRequestForAssetFromImage:imagePhoto];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"保存成功");
            [imageList removeObjectAtIndex:0];
        }
        [wself saveImageListToLibrary:imageList andLibraryNmae:libryName andSaveCallBack:completionHandler];
    }];
}

- (void)saveOnLineImageWithAuthorizationToPhotoLibraryWithImageList:(NSArray <NSString *> *)imageUrlList andLibraryName:(NSString *)libryName callBack:(QHSaveCompletionHandler)completionHandler {
    __weak __typeof__ (self) wself = self;

    self.downloadQueue.maxConcurrentOperationCount = self.maxConcurrentDownloadCount;
    [self.imagePathList removeAllObjects];
    
    NSBlockOperation *finalTask = [NSBlockOperation blockOperationWithBlock:^{
        __strong __typeof (wself) sself = wself;
        [sself backgroundSaveImageAndDeleteOldFilesWithLibraryName:libryName callBack:completionHandler];
    }];

    for (NSInteger i = 0; i < imageUrlList.count; i++) {
        QHDownloadOperation *task = [[QHDownloadOperation alloc] initWithImageUrlStr:[NSString stringWithFormat:@"%@",imageUrlList[i]] backgroundSupport:self.backgroundDownloadSupport withCompletionHandler:^(BOOL success, NSString * _Nullable filePath, NSError * _Nullable error) {
            __strong __typeof (wself) sself = wself;
            
            if(success && filePath != nil){
                [sself.imagePathList addObject:filePath];
            }
        }];
        [self.downloadQueue addOperation:task];
        [finalTask addDependency:task];
    }
    [self.downloadQueue addOperation:finalTask];
}

/**
 * 保存成功后的回调
 */
- (void)saveSuccessImageWithCompletionHandler:(QHSaveCompletionHandler)completionHandler {
   
    if (self.deleteDownloadImageCache) { //删除下载缓存数据
        [self delateOldFiles];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (completionHandler) {
            completionHandler(YES);
        }
    });
}

/**
 * 保存失败后的回调
 */
- (void)saveFailImageWithCompletionHandler:(QHSaveCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (completionHandler) {
            completionHandler(NO);
        }
    });
    
}

/**
 * 创建用户自定义相册
*/
- (PHAssetCollection *)createPHAssetLibraryWithName:(NSString *)libraryName{
    NSString *albumName = @"";
   
    if (libraryName == nil || [libraryName isEqualToString:@""]) {
        albumName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    } else {
        albumName = libraryName;
    }

    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *appCollection = nil;
   
    for (PHAssetCollection *collection in collections) {
        
        if ([collection.localizedTitle isEqualToString:albumName]) {
            return collection;
        }
    }
    
    if (appCollection == nil) {
        NSError *error = nil;
        __block NSString *createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        
        if (error) {
            return nil;
        } else {
            appCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
        }
    }

    return appCollection;
}

/**
 * 取消所有下载任务
 */
- (void)cancelAllDownloads {
   
    if (self.downloadQueue) {
        [self.downloadQueue cancelAllOperations];
    }
    
    [self delateOldFiles];
}

- (void)delateOldFiles {
   
    if (self.imagePathList.count > 0) {
        [self.imagePathList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:(NSString *)obj error:nil];
        }];
        [self.imagePathList removeAllObjects];
    }
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];
}
@end

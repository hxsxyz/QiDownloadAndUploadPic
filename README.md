# QhSaveImageToLibrary
### 多线程下载、上传图片。支持设置最大并发数，支持后台处理任务。没有使用任何第三方相关类库，系统原生方法实现，无依赖负担。
### 使用方式：
#### 1. 下载网络图片list
```
NSArray *imageUrlList = @[
        @"https://i.loli.net/2021/11/02/aYnZxByIC4u1GFX.jpg",
        @"https://i.loli.net/2021/11/02/2YMvcEGSZqAefRQ.jpg",
        @"https://i.loli.net/2021/11/02/pdF3jiDGTxLUPhl.jpg",
        @"https://i.loli.net/2021/11/02/OgBpvVI9L6X3qds.jpg",
        @"https://i.loli.net/2021/11/02/qoyLhApdReSXBxg.jpg",
        @"https://i.loli.net/2021/11/02/aYnZxByIC4u1GFX.jpg",
        @"https://i.loli.net/2021/11/02/2YMvcEGSZqAefRQ.jpg",
        @"https://i.loli.net/2021/11/02/pdF3jiDGTxLUPhl.jpg",
        @"https://i.loli.net/2021/11/02/OgBpvVI9L6X3qds.jpg",
        @"https://i.loli.net/2021/11/02/qoyLhApdReSXBxg.jpg"
    ];
    
    [[QHSavePicToPhotoLibraryManager sharedInstance] saveOnLineImageToPhotoLibraryWithImageList:imageUrlList andLibraryName:self.customLibraryName callBack:^(BOOL success) {
        [CXMProgressView dismissLoading];
        __strong __typeof (wself) sself = wself;
        
        if(success){
            NSLog(@"success=%d",success);
            [CXMProgressView showSuccessText:@"下载完成"];
        }else {
            [sself showAlert];
        }
    }];
```
#### 2. 上传图片list
```
 NSString *upLoadImage1 = [[NSBundle mainBundle] pathForResource:@"upLoad_01" ofType:@"png"];
    NSString *upLoadImage2 = [[NSBundle mainBundle] pathForResource:@"upLoad_02" ofType:@"jpg"];
    NSString *upLoadImage3 = [[NSBundle mainBundle] pathForResource:@"upLoad_03" ofType:@"jpg"];
    NSString *upLoadImage4 = [[NSBundle mainBundle] pathForResource:@"upLoad_01" ofType:@"png"];

    NSArray *imageArr = @[upLoadImage1,upLoadImage2,upLoadImage3,upLoadImage4];

    [[QHUploadPicToServeManager sharedInstance] uploadImageWithServeIp:ServeIp andServeFileParameter:ServeParameter andImagePathList:imageArr withCompletionHandler:^(BOOL success,NSArray *imageUrlList) {
        [CXMProgressView dismissLoading];
        
        if(success){
            [CXMProgressView showSuccessText:@"上传成功"];
            NSLog(@"imageUrlList=%@",imageUrlList);
        }
    }];
```

#### 3. 设置最大并发数

```
[QHUploadPicToServeManager sharedInstance].maxConcurrentUploadCount = 5;        [QHSavePicToPhotoLibraryManager sharedInstance].maxConcurrentDownloadCount = 5;
```
> 具体使用看Demo，你一看就会






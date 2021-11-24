//
//  ViewController.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/10/21.
//

#import "ViewController.h"
#import "QHDownloadAndUploadPic.h"
#import "CXMProgressView.h"

#define   ServeIp             @"https://sm.ms/api/v2/upload"
#define   ServeParameter      @"smfile"

@interface ViewController () <UITextFieldDelegate>
@property (copy, nonatomic) NSString *customLibraryName;

@property (weak, nonatomic) IBOutlet UITextField *customLibraryField;
@property (weak, nonatomic) IBOutlet UITextField *setMaxCocurrentCountField;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundTaskSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *whetherDeleateCacheSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    
    self.title = @"下载上传图片";
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    self.customLibraryName = appName;
    
    self.customLibraryField.delegate = self;
    self.setMaxCocurrentCountField.delegate = self;
}  

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) return;
    
    if (textField == self.setMaxCocurrentCountField) {
        [QHUploadPicToServeManager sharedInstance].maxConcurrentUploadCount = [textField.text integerValue];
        [QHSavePicToPhotoLibraryManager sharedInstance].maxConcurrentDownloadCount = [textField.text integerValue];
    }else {
        self.customLibraryName = [self.customLibraryField.text isEqualToString:@""] ? self.customLibraryName : self.customLibraryField.text;
    }
}

#pragma mark - UISwitch Action

- (IBAction)backgroundSwitchAction:(id)sender {
    UISwitch *backgroundSwitch = (UISwitch*)sender;
    [QHSavePicToPhotoLibraryManager sharedInstance].backgroundDownloadSupport = backgroundSwitch.on;
    [QHUploadPicToServeManager sharedInstance].backgroundUploadSupport = backgroundSwitch.on;
}

- (IBAction)whetherDeleteCacheSwicthAction:(id)sender {
    UISwitch *whetherDeleateCacheSwitch = (UISwitch*)sender;
    [QHSavePicToPhotoLibraryManager sharedInstance].deleteDownloadImageCache = whetherDeleateCacheSwitch.on;
}

#pragma mark - UIButton Action

- (IBAction)saveLocalImageToCustomLibraryClick:(id)sender {
    __weak __typeof (self) wself = self;
   
    [CXMProgressView showTextWithCircle:@"正在保存"];
    NSArray *imageList = @[
        [UIImage imageNamed:@"001.jpg"],
        [UIImage imageNamed:@"002.jpg"],
        [UIImage imageNamed:@"003.jpg"],
        [UIImage imageNamed:@"004.jpg"],
        [UIImage imageNamed:@"005.jpg"],
        [UIImage imageNamed:@"006.jpg"]];
    
    [[QHSavePicToPhotoLibraryManager sharedInstance] saveImageToPhotoLibraryWithImageList:imageList andLibraryName:self.customLibraryName callBack:^(BOOL success) {
        __strong __typeof (wself) sself = wself;
        [CXMProgressView dismissLoading];
        
        if (success) {
            NSLog(@"success=%d",success);
            [CXMProgressView showSuccessText:@"保存成功"];
        } else {
            [sself showAlert];
        }
    }];
}

- (IBAction)downloadImageToLibraryClick:(id)sender {
    [CXMProgressView showTextWithCircle:@"正在下载"];
  
    __weak __typeof (self) wself = self;
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
}

- (IBAction)upLoadImageListToServerClick:(id)sender {
    NSLog(@"%s",__func__);
   
    [CXMProgressView showTextWithCircle:@"正在上传"];
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showAlert {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-照片\"中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

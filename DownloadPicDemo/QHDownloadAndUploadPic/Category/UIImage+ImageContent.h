//
//  UIImage+ImageContent.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ImageFormatJPEG,
    ImageFormatPNG,
} ImageType;

@interface UIImage (ImageContent)

+ (NSData *)getDataWithImage:(UIImage *)image;

+ (ImageType)getImageTypeWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

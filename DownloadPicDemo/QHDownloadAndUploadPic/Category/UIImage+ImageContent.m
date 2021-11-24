//
//  UIImage+ImageContent.m
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/18.
//

#import "UIImage+ImageContent.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (ImageContent)
+ (NSData *)getDataWithImage:(UIImage *)image {
    
    if (!image) {
        return nil;
    }
    ImageType type;
    BOOL hasAlpha = CGImageRefContainsAlpha(image.CGImage);
    if (hasAlpha) {
        type = ImageFormatPNG;
    } else {
        type = ImageFormatJPEG;
    }
    
    NSMutableData *imageData = [NSMutableData data];
    CFStringRef imageUTType = [self utTypeFromSDImageFormat:type];
    
    // Create an image destination.
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, imageUTType, 1, NULL);
    if (!imageDestination) {
        // Handle failure.
        return nil;
    }
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
#if SD_UIKIT || SD_WATCH
    NSInteger exifOrientation = [SDWebImageCoderHelper exifOrientationFromImageOrientation:image.imageOrientation];
    [properties setValue:@(exifOrientation) forKey:(__bridge_transfer NSString *)kCGImagePropertyOrientation];
#endif
    
    // Add your image to the destination.
    CGImageDestinationAddImage(imageDestination, image.CGImage, (__bridge CFDictionaryRef)properties);
    
    // Finalize the destination.
    if (CGImageDestinationFinalize(imageDestination) == NO) {
        // Handle failure.
        imageData = nil;
    }
    
    CFRelease(imageDestination);
    
    return [imageData copy];
}

+ (nonnull CFStringRef)utTypeFromSDImageFormat:(ImageType)format {
    CFStringRef UTType;
    switch (format) {
        case ImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case ImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        default:
            // default is kUTTypePNG
            UTType = kUTTypePNG;
            break;
    }
    return UTType;
}

+ (ImageType)getImageTypeWithImage:(UIImage *)image {
    
    if (!image) {
        return ImageFormatPNG;
    }
    ImageType type;
    BOOL hasAlpha = CGImageRefContainsAlpha(image.CGImage);
    if (hasAlpha) {
        type = ImageFormatPNG;
    } else {
        type = ImageFormatJPEG;
    }
    return type;
}

BOOL CGImageRefContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

@end

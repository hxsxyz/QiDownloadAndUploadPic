//
//  CXMProgressView.h
//  MBProgressHud_Demo
//
//  Created by 陈小明 on 2016/12/12.
//  Copyright © 2016年 bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void(^ProgressHideComplete)(void);

@interface CXMProgressView : NSObject

/**
 * @brief 只显示纯文本
 * @param aText 要显示的文本
 */
+ (void)showText:(NSString*)aText;

/**
 * @brief 显示纯文本 加一个转圈
 * @param aText 要显示的文本
*/
+ (void)showTextWithCircle:(NSString *)aText;

/**
 *  @brief 隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
+ (void)dismissLoading;

/**
 *  @brief 显示错误信息
 *
 *  @param aText 错误信息文本
 */
+ (void)showErrorText:(NSString *)aText;

/**
 *  @brief 显示成功信息
 *
 *  @param aText 成功信息文本
 */
+ (void)showSuccessText:(NSString *)aText;

/**
 *  @brief 显示文本信息，以及hud隐藏后的回掉
 *  @param aText 成功信息文本
 *  @param complete 展示完成后的回掉
 */
+ (void)showText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;

/**
 *  @brief 显示成功文本信息，以及hud隐藏后的回掉
 *  @param aText 成功信息文本
 *  @param complete 展示完成后的回掉
 */
+ (void)showSuccessText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;

/**
 *  @brief 显示错误文本信息，以及hud隐藏后的回掉
 *  @param aText 错误信息文本
 *  @param complete 展示完成后的回掉
 */
+ (void)showErrorText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;

/**
 *  @brief 展示变换的文字，加一个圈
 *  @param anmiationText 标题
 *  @param detailLabel 副标题
 */
- (void)showHudWithAnmiationText:(NSString*)anmiationText detailLabel:(NSString*)detailLabel;
/**
 * @brief 隐藏 Hud
 */
- (void)hiddenInstanceHUD;


@end

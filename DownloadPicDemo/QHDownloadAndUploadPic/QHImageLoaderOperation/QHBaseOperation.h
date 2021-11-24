//
//  QHBaseOperation.h
//  DownloadPicDemo
//
//  Created by 陈小明 on 2021/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHBaseOperation : NSOperation

@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (assign, nonatomic) BOOL backgroundSupport;
@property (strong, nonatomic, nullable) NSURLSession *session;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

- (void)startTask;
- (void)cancelTask;
- (void)done;
@end

NS_ASSUME_NONNULL_END

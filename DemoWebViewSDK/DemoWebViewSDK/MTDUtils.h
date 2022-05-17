//
//  MTDUtils.h
//  DemoWebViewSDK
//
//  Created by Lan Le on 11.05.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTDUtils : NSObject

- (void)downloadFrom:(NSString *)url
    downloadProgress:(void (^_Nullable)(float progress))downloadProgressHandler
       upzipProgress:(void (^_Nullable)(float progress))upzipProgressHandler
   completionHandler:(void (^)(NSString * _Nullable webPath, BOOL succeeded, NSError * _Nullable error))downloadCompletionHandler;

@end

NS_ASSUME_NONNULL_END

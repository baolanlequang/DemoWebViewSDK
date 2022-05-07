//
//  MTDController.h
//  DemoWebViewSDK
//
//  Created by Lan Le on 07.05.22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTDController : UIViewController

- (instancetype)init;
- (void)loadURL:(NSString *)url;
- (void)loadLocalPath:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

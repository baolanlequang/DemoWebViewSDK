//
//  ViewController.m
//  TestWebViewSDK
//
//  Created by Lan Le on 07.05.22.
//

#import "ViewController.h"
#import <DemoWebViewSDK/DemoWebViewSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MTDUtils *myUtils = [[MTDUtils alloc] init];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [myUtils downloadFrom:@"https://github.com/baolanlequang/DemoSDK/raw/master/web_1.zip" downloadProgress:^(float progress) {
            NSLog(@"downloaded: %f%%", progress*100);
        } upzipProgress:^(float progress) {
            NSLog(@"upzipProgress: %f%%", progress*100);
        } completionHandler:^(NSString * _Nullable webPath, BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    MTDController *myVC = [[MTDController alloc] init];
                    [self.navigationController presentViewController:myVC animated:TRUE completion:^{
                        [myVC loadLocalPath:webPath];
                    }];
                });
            }
            else {
                NSLog(@"error: %@", error.userInfo);
            }
        }];
        
    });
    
    

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

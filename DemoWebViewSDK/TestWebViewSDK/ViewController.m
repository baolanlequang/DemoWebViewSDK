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
//        [myUtils downloadFrom:@"https://github.com/baolanlequang/DemoSDK/raw/master/web_2.zip" completionHandler:^(NSString * _Nullable webPath, NSError * _Nullable error) {
//            NSLog(@"webPath: %@", webPath);
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                //Run UI Updates
//                MTDController *myVC = [[MTDController alloc] init];
//                [self.navigationController presentViewController:myVC animated:TRUE completion:^{
//                    [myVC loadLocalPath:webPath];
//                }];
//            });
//        }];
        
        [myUtils downloadFrom:@"https://github.com/baolanlequang/DemoSDK/raw/master/web_2.zip" progressHandler:^(long entryNumber, long total) {
            NSLog(@"entry: %ld, total: %ld", entryNumber, total);
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

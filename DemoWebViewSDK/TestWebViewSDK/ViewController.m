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
    
    MTDController *myVC = [[MTDController alloc] init];
    [self.navigationController presentViewController:myVC animated:TRUE completion:^{
        [myVC loadLocalPath:@"TestData/web_1/index.html"];
    }];
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

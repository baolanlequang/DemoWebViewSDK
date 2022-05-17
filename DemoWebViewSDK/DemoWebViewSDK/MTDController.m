//
//  MTDController.m
//  DemoWebViewSDK
//
//  Created by Lan Le on 07.05.22.
//

#import "MTDController.h"
#import <WebKit/WebKit.h>
#import "MTDConfig.h"

@interface MTDController () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation MTDController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor redColor];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self settingWebView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

# pragma mark - SETTING
- (void)settingWebView {
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webConfiguration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
}

- (void)loadURL:(NSString *)url {
    NSURL *myURL = [NSURL URLWithString:url];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    [_webView loadRequest:myRequest];
}

- (void)loadLocalPath:(NSString *)url {
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) firstObject];
//    NSLog(@"paths: %@", paths);
    NSURL *folderPath = [[NSURL fileURLWithPath:paths] URLByAppendingPathComponent:FOLDER_NAME isDirectory: YES];
    folderPath = [folderPath URLByAppendingPathComponent:url isDirectory:YES];
//    NSLog(@"folderPath: %@", folderPath);
    NSString *filePath = [folderPath URLByAppendingPathComponent:@"index.html"].path;
//    NSLog(@"filePath: %@", filePath);
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
//    NSLog(@"fileURL: %@", fileURL);
    [_webView loadFileURL:fileURL allowingReadAccessToURL:folderPath];
}

# pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

# pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"err: %@", error);
}

@end

//
//  MTDController.m
//  DemoWebViewSDK
//
//  Created by Lan Le on 07.05.22.
//

#import "MTDController.h"
#import <WebKit/WebKit.h>

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
    NSLog(@"paths: %@", paths);
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", paths, url];
    NSURL *myURL = [NSURL fileURLWithPath:filePath];
    NSLog(@"myURL: %@", myURL);
    [_webView loadFileURL:myURL allowingReadAccessToURL:myURL];
}

# pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}

# pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"WKUIDelegate");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"err: %@", error);
}

@end

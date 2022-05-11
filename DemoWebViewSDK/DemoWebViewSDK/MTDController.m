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
//    NSFileManager* fm = [NSFileManager new];
//    NSError* err = nil;
//    NSURL* docsurl =
//        [fm URLForDirectory:NSDocumentDirectory
//                   inDomain:NSUserDomainMask appropriateForURL:nil
//                     create:YES error:&err];
//    // error checking omitted
//    NSURL* myfolder = [docsurl URLByAppendingPathComponent:@"MyTestData"];
//    BOOL ok =
//        [fm createDirectoryAtURL:myfolder
//            withIntermediateDirectories:YES attributes:nil error:&err];
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@/index.html", paths, FOLDER_NAME, url];
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
    [webView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"result: %@", result);
    }];
    
//    webView.evaluateJavaScript("document.documentElement.outerHTML", completionHandler: { result, error in
//          if let datHtml = result as? String {
//             print(datHtml)
//             // parse datHtml here
//             }
//          } )
//        }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *myRequest = navigationAction.request;
//    NSLog(@"decidePolicyForNavigationAction: %@", myRequest.URL.lastPathComponent);
//    NSString *html = [self getDataFromRequest:myRequest];
//    NSLog(@"html: %@", html);
    decisionHandler(WKNavigationActionPolicyAllow);
}
////
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
////    NSURLResponse *myRespone = navigationResponse.response;
////    NSLog(@"decidePolicyForNavigationResponse: %@", myRespone.URL.lastPathComponent);
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}

# pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"WKUIDelegate");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"err: %@", error);
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (NSString *) getDataFromRequest:(NSMutableURLRequest *)request {
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting, HTTP status code %i", [responseCode statusCode]);
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}



@end

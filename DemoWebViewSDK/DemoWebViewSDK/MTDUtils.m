//
//  MTDUtils.m
//  DemoWebViewSDK
//
//  Created by Lan Le on 11.05.22.
//

#import "MTDUtils.h"
#import "ThirdParties/Zip/SSZipArchive.h"

@implementation MTDUtils

+ (void)downloadFrom:(NSString *)url {
    NSURL *urlObj = [NSURL URLWithString:url];
    if (![urlObj isEqual:nil]) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlObj];
        NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (![location isEqual:nil]) {
                @try {
                    NSLog(@"location: %@", location);
                    NSFileManager* fm = [NSFileManager new];
                    NSError* err = nil;
                    NSURL* docsurl =
                        [fm URLForDirectory:NSDocumentDirectory
                                   inDomain:NSUserDomainMask appropriateForURL:nil
                                     create:YES error:&err];
                    NSURL* myfolder = [docsurl URLByAppendingPathComponent:location.lastPathComponent];
                    [fm moveItemAtURL:location toURL:myfolder error:&err];
                    NSString *zipPath = myfolder.path;
                    NSString *destinationPath = docsurl.path;
                    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
                    
                } @catch (NSException *exception) {
                    NSLog(@"exception: %@", exception);
                }
            }
            else {
                NSLog(@"downloadTaskWithRequest");
            }
        }];
        [downloadTask resume];
    }
}


@end

//
//  MTDUtils.m
//  DemoWebViewSDK
//
//  Created by Lan Le on 11.05.22.
//

#import "MTDUtils.h"
#import "ThirdParties/Zip/SSZipArchive.h"
#import "MTDConfig.h"

@interface MTDUtils () <SSZipArchiveDelegate>

@property (copy, nonatomic) void (^downloadCompletionHandler)(NSString * _Nullable webPath, NSError * _Nullable error);
@property (copy, nonatomic) NSString *zipFileName;

@end

@implementation MTDUtils

- (void)downloadFrom:(NSString *)url completionHandler:(void (^)(NSString * _Nullable webPath, NSError * _Nullable error))downloadCompletionHandler {
    _downloadCompletionHandler = downloadCompletionHandler;
    NSURL *urlObj = [NSURL URLWithString:url];
    _zipFileName = [self getFileNameFrom:urlObj];
    if (![urlObj isEqual:nil]) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlObj];
        NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (![location isEqual:nil]) {
                @try {
                    NSFileManager* fm = [NSFileManager new];
                    NSError* err = nil;
                    NSURL* docsurl =
                        [fm URLForDirectory:NSDocumentDirectory
                                   inDomain:NSUserDomainMask appropriateForURL:nil
                                     create:YES error:&err];
                    NSURL* myfolder = [docsurl URLByAppendingPathComponent:location.lastPathComponent];
                    [fm moveItemAtURL:location toURL:myfolder error:&err];
                    NSString *zipPath = myfolder.path;
                    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@/", docsurl.path, FOLDER_NAME];
                    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath overwrite:YES password:@"" error:&error delegate:self];
                    
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

- (NSString *)getFileNameFrom:(NSURL *)url {
    if (![url isEqual:nil]) {
        NSString *lastComponent = url.lastPathComponent;
        NSArray *nameComponents = [lastComponent componentsSeparatedByString:@"."];
        return nameComponents.firstObject;
    }
    return nil;
}

# pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    _downloadCompletionHandler(_zipFileName, nil);
}

@end

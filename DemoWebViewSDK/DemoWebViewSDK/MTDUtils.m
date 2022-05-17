//
//  MTDUtils.m
//  DemoWebViewSDK
//
//  Created by Lan Le on 11.05.22.
//

#import "MTDUtils.h"
#import "ThirdParties/Zip/SSZipArchive.h"
#import "MTDConfig.h"
#import "ThirdParties/AFNetworking/AFNetworking.h"

@interface MTDUtils ()

@property (copy, nonatomic) NSString *zipFileName;

@end

@implementation MTDUtils

- (void)downloadFrom:(NSString *)url downloadProgress:(void (^)(float))downloadProgressHandler upzipProgress:(void (^)(float))upzipProgressHandler completionHandler:(void (^)(NSString * _Nullable, BOOL, NSError * _Nullable))downloadCompletionHandler {
    NSURL *urlObj = [NSURL URLWithString:url];
    _zipFileName = [self getFileNameFrom:urlObj];
    if (![urlObj isEqual:nil]) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlObj];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            downloadProgressHandler(downloadProgress.fractionCompleted);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            NSLog(@"File downloaded to: %@", filePath);
            if (![filePath isEqual:nil]) {
                @try {
                    NSFileManager* fm = [NSFileManager new];
                    NSError* err = nil;
                    NSURL* docsurl =
                        [fm URLForDirectory:NSDocumentDirectory
                                   inDomain:NSUserDomainMask appropriateForURL:nil
                                     create:YES error:&err];
                    NSURL* myfolder = [docsurl URLByAppendingPathComponent:filePath.lastPathComponent];
                    [fm moveItemAtURL:filePath toURL:myfolder error:&err];
                    NSString *zipPath = myfolder.path;
                    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@/", docsurl.path, FOLDER_NAME];
                    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                        float progress = (float)entryNumber/total;
                        upzipProgressHandler(progress);
                    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                        downloadCompletionHandler(self.zipFileName, succeeded, error);
                    }];

                } @catch (NSException *exception) {
                    NSError *err = [NSError errorWithDomain:@"MetaNode" code:-100 userInfo:exception.userInfo];
                    downloadCompletionHandler(nil, false, err);
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

@end

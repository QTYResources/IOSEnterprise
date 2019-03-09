//
//  ViewController.m
//  UseAFNetworking
//
//  Created by QinTuanye on 2019/3/5.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

// 如果请求地址和端口发生变化，只需在这里修改
#define ServerDomain @"http://192.168.10.172:8899/"
#define kOrderServerUrl [ServerDomain stringByAppendingString:@"prj/app/order"]
#define kMineServerUrl ServerDomain@"prj/app/mine"
#define kStoreServerUrl ServerDomain@"prj/app/store"

@interface ViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
// 下载操作
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 开始下载
    [self.downloadTask resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 暂停下载
    [self.downloadTask response];
}

- (void)dealloc
{
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
}

// 使用NSURLSession
//- (NSURLSessionTask *)downloadTask {
//    if (_downloadTask == nil) {
//
//        NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/img/bdlogo.png"];
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myUniqueAppId"];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//
//        // 请求
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        // 一个带有URL的请求
//        _downloadTask = [session downloadTaskWithRequest:request];
//    }
//    return _downloadTask;
//}

// 使用AFNetworking
- (NSURLSessionTask *)downloadTask {
    if (_downloadTask == nil) {
        NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/img/bdlogo.png"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // AFNetworking 3.0+基于URLSession封装的句柄
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        // 请求
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        // 下载Task操作
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // downloadProgress的两个属性
            // @property int64_t totalUnitCount;    需要下载文件的总大小
            // @property init64_t completedUnitCount;   当前已经下载的大小
            // 给Progress添加监听KVO
            NSLog(@"下载的进度=%f", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            // 切换到主线程刷新UI，通过progressView显示下载进度条
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // Block的返回值，要求返回一个URL，返回的这个URL就是文件下载后所在的路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                // filePath就是下载文件的路径；如果是zip文件，需要在这里解压缩
                NSString *imgFilePath = [filePath path];    // 将NSURL转成NSString
                UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
                self.imageView.image = img;
            } else {
                NSLog(@"Download error: %@", error);
            }
        }];
    }
    return _downloadTask;
}

- (void)getRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    // iOS请求数据编码为二进制格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 后台数据返回数据编码是JSON格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kOrderServerUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
}

- (void)asyncRequest {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        NSError *error;
        NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"根据后台返回的数据， 更新UI %@", data);
            });
        } else {
            NSLog(@"error when download: %@", error);
        }
    });
}

#pragma mark - <NSURLSessionDownloadDelegate>
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;    // 能和下载的进度
    self.progressView.progress = percentDone;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes; {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 文件下载完成后，将下载的临时文件移到永久性的目录中，并删除临时文件。如果是压缩文件，解压的过程也是这里完成的
    // filePath就是下载文件的路径；如果是zip文件，需要在这里解压缩
    NSString *imgFilePath = [location path];    // 将NSURL转成NSString
    NSLog(@"imgFilePath: %@", imgFilePath);
    NSData *data = [NSData dataWithContentsOfFile:imgFilePath];
    UIImage *img = [UIImage imageWithData:data];
    self.imageView.image = img;
}

@end

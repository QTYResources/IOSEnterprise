UseAFNetworking

AFNetworking第三方网络库的使用方法

（1）异步请求数据并更新UI
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

（2）AFNetworking的GET请求
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

（3）AFNetworking的文件下载
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

（4）NSURLSession的文件下载
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/img/bdlogo.png"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myUniqueAppId"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    // 一个带有URL的请求
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    // 开始下载
    [downloadTask resume];
    // 暂停下载
    [downloadTask response];
    // 取消下载
    [downloadTask cancel];
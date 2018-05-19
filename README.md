##七牛云存储初试


1、收费说明

10GB永久免费存储空间

每月10GB下载流量

每月10万次Put请求

每月100万次Get请

其他消费
https://support.qiniu.com/hc/kb/article/112874/

2、token

上传策略

http://developer.qiniu.com/docs/v6/api/reference/security/upload-token.html

在线生成token（仅限测试使用）

http://jsfiddle.net/gh/get/extjs/4.2/icattlecoder/jsfiddle/tree/master/uptoken



3、图片缩略图

直接在url后面拼接

//限定长边，生成不超过300x300的缩略图

http://o7q1p0cew.bkt.clouddn.com/2016-05-25_16:59:35_r7Vcmt46.jpg?imageMogr2/thumbnail/300x300

//旋转45度等

?imageMogr2/rotate/45   

相关链接

http://developer.qiniu.com/code/v6/api/kodo-api/image/imagemogr2.html



4、视频帧视图

http://106.39.192.36/xdispatch/o7q1p0cew.bkt.clouddn.com/2016-05-26_16:02:26_ozFerJsr.mp4?vframe/jpg/offset/0/w/480/h/360

？vframe/格式/offset/截取时刻/w/宽/h/高



http://developer.qiniu.com/code/v6/api/dora-api/av/vframe.html


5、上传接口测试成功
- (void)uploadVedioToQNFilePath:(NSString *)filePath {

NSData* data = [NSData dataWithContentsOfFile:filePath];

NSString *fileName = [NSString stringWithFormat:@"%@_%@.mp4", [self getDateTimeString], [self randomStringWithLength:8]];

QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
NSLog(@"percent == %.2f", percent);
}
params:nil
checkCrc:NO
cancellationSignal:nil];

[self.upManager putData:data
key:fileName
token:self.token
complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

NSLog(@" --->> Info: %@  ", info);
NSLog(@" ---------------------");
NSLog(@" --->> Response: %@,  ", resp);
}
option:uploadOption];





}


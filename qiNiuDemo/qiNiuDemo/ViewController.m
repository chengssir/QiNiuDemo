//
//  ViewController.m
//  QiNiu
//
//  Created by 快乐的小苹果 on 16/5/25.
//  Copyright © 2016年 快乐的小苹果. All rights reserved.
//

#import "ViewController.h"
#import <qiNiuSDK/qiNiuSDK.h>
#import "UIImageView+WebCache.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UIImage *pickImage;
//@property (nonatomic, strong) QNUploadManager *upManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"七牛云上传测试";

    //上传token 文档地址
    // http://developer.qiniu.com/docs/v6/api/reference/security/upload-token.html

}

- (IBAction)uploadAction:(id)sender {

    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 设置图片

    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1);
    [self uploadImageToQNFileData:imageData];

}

- (void)uploadImageToQNFileData:(NSData *)data{

    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];

    [[QNUploadManager sharedInstance] putData:data
                                          key:fileName
                                        token:[QiniuAuthPolicy token_ceshi1]
                                     complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                                         NSLog(@" --->> Info: %@  ", info);
                                         NSLog(@" ---------------------");
                                         NSLog(@" --->> Response: %@,  ", resp);
                                         if (!resp[@"key"]) {
                                             return;
                                         }
                                         NSString *imageUrl = [NSString stringWithFormat:@"%@%@",QiNiu_URL,resp[@"key"]];
                                         [self.imageWebView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"voice_trans_fail.png"]];


                                     }
                                       option:uploadOption];


}

//图片路径
- (void)uploadImageToQNFilePath:(NSString *)filePath {


    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];

    [[QNUploadManager sharedInstance] putFile:filePath
                                          key:fileName
                                        token:[QiniuAuthPolicy token_ceshi1]
                                     complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                                         NSLog(@" --->> Info: %@  ", info);
                                         NSLog(@" ---------------------");
                                         NSLog(@" --->> Response: %@,  ", resp);

                                         if (!resp[@"key"]) {
                                             return;
                                         }
                                         NSString *imageUrl = [NSString stringWithFormat:@"%@%@",QiNiu_URL,resp[@"key"]];
                                         [self.imageWebView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];


                                         
                                     }
                                       option:uploadOption];





}

//路径上传
- (void)uploadFileToQNFilePath:(NSString *)filePath {

    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@.mp4", [self getDateTimeString], [self randomStringWithLength:8],[self getDateTimeString]];

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];

    [[QNUploadManager sharedInstance] putFile:filePath
                        key:fileName
                      token:[QiniuAuthPolicy token_ceshi1]
                   complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                       NSLog(@" --->> Info: %@  ", info);
                       NSLog(@" ---------------------");
                       NSLog(@" --->> Response: %@,  ", resp);
                   }
                     option:uploadOption];



}

//文件data上传
- (void)uploadVedioToQNFilePath:(NSString *)filePath {

    NSData* data = [NSData dataWithContentsOfFile:filePath];

    NSString *fileName = [NSString stringWithFormat:@"%@_%@.mp4", [self getDateTimeString], [self randomStringWithLength:8]];

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];

    [[QNUploadManager sharedInstance] putData:data
                        key:fileName
                      token:[QiniuAuthPolicy token_ceshi1]
                   complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                       NSLog(@" --->> Info: %@  ", info);
                       NSLog(@" ---------------------");
                       NSLog(@" --->> Response: %@,  ", resp);
                   }
                     option:uploadOption];

}


#pragma  断点续传测试
-(void)updataFile:(NSString *)fileName{

    /*
     *  注意事项：1、必须保证有缓存的目录
     *          2、必须保证文件名和缓存中的一致
     *
     */

    NSError *error = nil;
    //断点过程中缓存的目录
    QNFileRecorder *file = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"qiniutest"] error:&error];
    //本地文件地址
    NSURL *tempFile = [self createTempfileWithSize:15000 * 1024];
    //关联缓存目录
    QNUploadManager *upManager2 = [[QNUploadManager alloc] initWithRecorder:file];
    //打印上传进入cancellationSignal可以取消本地上传
    QNUploadOption *opt2 = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"continue progress %f", percent);
    }
                                                         params:nil
                                                       checkCrc:NO
                                             cancellationSignal:nil];
    //上传代码
    [upManager2 putFile:tempFile.path key:fileName token:[QiniuAuthPolicy token_ceshi1] complete:^(QNResponseInfo *info, NSString *k, NSDictionary *resp) {
        NSLog(@" --->> Info: %@  ", info);
        NSLog(@" ---------------------");
        NSLog(@" --->> Response: %@,  ", resp);
    }
                 option:opt2];

}


#pragma mark - Helpers

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

//在本地目录下创建一个文件
- (NSURL *)createTempfileWithSize:(int)size {

    NSString *string = [NSTemporaryDirectory() stringByAppendingPathComponent:@"12345678901_file.txt"];
    NSURL *fileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"12345678901_file.txt"]];

    if(![[NSFileManager defaultManager] fileExistsAtPath:string]){
        NSData *data = [NSMutableData dataWithLength:size];
        NSError *error = nil;
        [data writeToURL:fileUrl options:NSDataWritingAtomic error:&error];

    }
    return fileUrl;
}

- (void)removeTempfile:(NSURL *)fileUrl {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

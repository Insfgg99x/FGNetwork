//
//  DataService.m
//  DataService
//
//  Created by 夏桂峰 on 15/12/21.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//

#import "FGNetwork.h"
#import <UIKit/UIKit.h>

@interface FGNetwork()
{
    NSURLSession *_session;
}
@end

static NSString *const boundaryStr=@"--";
static NSString *const randomIDStr=@"haha";

static FGNetwork *service=nil;

@implementation FGNetwork

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[FGNetwork alloc]init];
    });
    return service;
}

-(instancetype)init{
    
    if(self=[super init]){
        
        //缓存路径
        NSString *cachePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DataServiceCaches"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:cachePath]){
            
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //缓存大小
        NSURLCache *cache=[[NSURLCache alloc]initWithMemoryCapacity:10*1024*1024
                                                       diskCapacity:50*1024*1024
                                                           diskPath: cachePath];
        //配置
        NSURLSessionConfiguration *cfg=[NSURLSessionConfiguration defaultSessionConfiguration];
        //缓存设置
        [cfg setURLCache:cache];
        _session=[NSURLSession sessionWithConfiguration:cfg];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}
-(void)appWillTerminate:(NSNotification *)sender{
    
    [self cancelAllDataTask];
}
/**
 *  get请求
 *  urlString   链接
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)get:(NSString *)urlString success:(void (^)(NSData *, NSURLResponse *))success failure:(void (^)(NSError *))failure{
    
    [[_session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error){
                
                if(success)
                    success(data,response);
            }
            else
            {
                if(failure)
                    failure(error);
            }
        });
    }] resume];
}
/**
 *  post请求
 *  urlString   主地址
 *  paramaters  参数字典
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)post:(NSString *)urlString paramaters:(NSString *)paramaters success:(void (^)(NSData *, NSURLResponse *))success failure:(void (^)(NSError *))failure{
    
    if((urlString.length==0)||(!urlString)){
        
        NSLog(@"---DataService---:主地址不能为空");
        return;
    }
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPBody=[paramaters dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod=@"POST";
    //超时为2分钟
    [request setTimeoutInterval:120];
    [[_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error&&data){
                
                if(success)
                    success(data,response);
            }
            else{
                
                if(failure)
                    failure(error);
            }
        });
    }] resume];
}
/**
 *  文件上传
 *  urlString   服务器地址
 *  fileData    文件二进制数据
 *  paramaters  参数字典
 *  name        服务器文件的变量名
 *  fileName    文件名
 *  mimeType    Content-Type
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)uploadFileToHost:(NSString *)urlString fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^)(NSData *, NSURLResponse *))success failure:(void (^)(NSError *))failure{
    
    if((urlString.length==0)||(!urlString)){
        
        NSLog(@"---DataService---:主地址不能为空");
        return;
    }
    
    //固定拼接格式第一部分
    NSMutableString *top = [NSMutableString string];
    [top appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [top appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", name, fileName];
    [top appendFormat:@"Content-Type: %@\n\n", mimeType];
    
    //固定拼接第二部分
    NSMutableString *buttom = [NSMutableString string];
    [buttom appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [buttom appendString:@"Content-Disposition: form-data; name=\"submit\"\n\n"];
    [buttom appendString:@"Submit\n"];
    [buttom appendFormat:@"%@%@--\n", boundaryStr, randomIDStr];
    
    //容器
    NSMutableData *fromData=[NSMutableData data];
    //非文件参数
    [fromData appendData:[paramaters dataUsingEncoding:NSUTF8StringEncoding]];
    [fromData appendData:[top dataUsingEncoding:NSUTF8StringEncoding]];
    //文件数据部分
    [fromData appendData:fileData];
    [fromData appendData:[buttom dataUsingEncoding:NSUTF8StringEncoding]];
    
    //可变请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPBody=fromData;
    request.HTTPMethod=@"POST";
    [request addValue:@(fromData.length).stringValue forHTTPHeaderField:@"Content-Length"];
    NSString *strContentType=[NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    [[_session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error){
                
                if(success)
                    success(data,response);
            }
            else{
                
                if(failure)
                    failure(error);
            }
        });
    }] resume];
}
-(void)uploadMultiFileToHost:(NSString *)urlString imgs:(NSArray *)imgs name:(NSString *)name mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^)(NSData *data, NSURLResponse *response))success failure:(void (^)(NSError *error))failure{
    
    if((urlString.length==0)||(!urlString)){
        
        NSLog(@"---DataService---:主地址不能为空");
        return;
    }
    //容器
    NSMutableData *fromData=[NSMutableData data];
    
    NSString *end=[NSString stringWithFormat:@"%@%@--\n", boundaryStr, randomIDStr];
    for(int i=0;i<imgs.count;i++){
        NSString *varName=[NSString stringWithFormat:@"%@%d",name,i];
        NSString *fileName=[NSString stringWithFormat:@"image%d.jpg",i+1];
        NSData *imgData=UIImageJPEGRepresentation(imgs[i], 1);
        //固定拼接格式第一部分
        NSMutableString *top = [NSMutableString string];
        [top appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
        [top appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", varName, fileName];
        [top appendFormat:@"Content-Type: %@\n\n", mimeType];
        
        //固定拼接第二部分
        NSString *buttom =@"\n";
        
        [fromData appendData:[top dataUsingEncoding:NSUTF8StringEncoding]];
        //文件数据部分
        [fromData appendData:imgData];
        [fromData appendData:[buttom dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [fromData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //非文件参数
    [fromData appendData:[paramaters dataUsingEncoding:NSUTF8StringEncoding]];
    //可变请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPBody=fromData;
    request.HTTPMethod=@"POST";
    [request setValue:@(fromData.length).stringValue forHTTPHeaderField:@"Content-Length"];
    NSString *strContentType=[NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    [[_session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error){
                
                if(success)
                    success(data,response);
            }
            else
            {
                if(failure)
                    failure(error);
            }
        });
    }] resume];
}

-(void)cancelAllDataTask{
    
    [_session invalidateAndCancel];
}
@end

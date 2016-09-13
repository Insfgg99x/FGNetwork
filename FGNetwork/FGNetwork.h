//
//  DataService.h
//  DataService
//
//  Created by 夏桂峰 on 15/12/21.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGNetwork : NSObject

/**
 *  单例
 */
+(instancetype)shared;

/**
 *  get请求
 *  urlString   链接
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)get:(NSString *)urlString success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
/**
 *  post请求
 *  urlString   主地址
 *  paramaters  参数字典
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)post:(NSString *)urlString paramaters:(NSString *)paramaters success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
/**
 *  文件上传
 *  urlString   服务器地址
 *  fileData    文件二进制数据
 *  mimeType    MIME Type
 *  paramaters  参数字典
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)uploadFileToHost:(NSString *)urlString fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
/**上传多张照片（2张）file应该对应多个变量名儒file0，file1*/
-(void)uploadMultiFileToHost:(NSString *)urlString imgs:(NSArray *)imgs name:(NSString *)name mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^)(NSData *data, NSURLResponse *response))success failure:(void (^)(NSError *error))failure;
/**
 *  取消所有数据请求
 */
-(void)cancelAllDataTask;

@end

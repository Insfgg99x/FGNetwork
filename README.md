###FGNetwork
..............................................................
##Introduction
 A light networking  kit for iOS,
##Installtion
Manual:

Download This Project and drag the FGNetwork folder into your peroject, do not forget to ensure "copy item if need" being selected.


##Usage
Just import the header file:`import "FGNetwork.h"`
>Singleton

```
/**
 *  单例
 */
+(instancetype)shared;
```

>GET:

```
/**
 *  get请求
 *  urlString   链接
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)get:(NSString *)urlString success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
```
>POST:

```
/**
 *  post请求
 *  urlString   主地址
 *  paramaters  参数字典
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)post:(NSString *)urlString paramaters:(NSString *)paramaters success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
```
>And file upload supported:

```
/**
 *  文件上传
 *  urlString   服务器地址
 *  fileData    文件二进制数据
 *  mimeType    MIME Type
 *  paramaters  参数字典
 *  success     成功的回调
 *  failure     失败的回调
 */
-(void)uploadFileToHost:(NSString *)urlString fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^) (NSData *data, NSURLResponse *response)) success failure:(void (^) (NSError *error))failure;
```
>Multi files upload supported:

```
/**上传多张照片（2张）file应该对应多个变量名儒file0，file1*/
-(void)uploadMultiFileToHost:(NSString *)urlString imgs:(NSArray *)imgs name:(NSString *)name mimeType:(NSString *)mimeType paramaters:(NSString *)paramaters success:(void (^)(NSData *data, NSURLResponse *response))success failure:(void (^)(NSError *error))failure;
```
>And  a optional function:

```
/**
 *  取消所有数据请求
 */
-(void)cancelAllDataTask;
```
##Example
```
-(void)downloadData{
    
    [[FGNetwork shared] get:@"http://www.baidu.com" success:^(NSData *data, NSURLResponse *response) {
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
    } failure:^(NSError *error) {
        
    }];
}
```
The result is `恭喜發財`
##About Me
>Blog:     [CGPointZeero](http://cgpointzero.top)
GitHub:   [Insfgg99x](https://github.com/Insfgg99x)
Mooc:     [CGPointZero](http://www.imooc.com/u/3909164/articles)
Jianshu:  [CGPointZero](http://www.jianshu.com/users/c3f2e8c87dc4/latest_articles)
Email:    [newbox0512@yahoo.com](mailto:newbox0512@yahoo.com)

..............................................................

@CGPoitZero
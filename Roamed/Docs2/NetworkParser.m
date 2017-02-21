	//
//  NetworkParser.m
//  SchoolApp
//
//  Created by TwinkleStar on 11/27/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import "NetworkParser.h"
#import "AFNetworking.h"
#import "CGlobal.h"
#import "BaseModel.h"
#import "Roamed-Swift.h"

@implementation NetworkParser

+ (instancetype)sharedManager
{
    static NetworkParser *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[NetworkParser alloc] init];
        
    });
    
    return sharedPhotoManager;
}
-(BOOL)checkResponse:(NSDictionary*)dict{
    @try {
        if ([dict objectForKey:@"response"] == nil) {
            return true;
        }else{
            NSNumber* code = [dict valueForKey:@"response"];
            if ([code intValue] == 200) {
                return true;
            }else if([code intValue] == 105){
                NSString*error = (NSString*)[dict objectForKey:@"error"];
                if (error != nil) {
                    [CGlobal AlertMessage:error Title:@"Error 105"];
                }
                
            }
            return false;
        }
        
    }
    @catch (NSException *exception) {
        return false;
    }
    @finally {
        
    }
    
}
-(void)generalNetworkWithNoCheck:(NSString*)serverurl Data:(NSDictionary*)questionDict withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([[serverurl lowercaseString] hasPrefix:@"https://"]) {
        manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    
    
    
    [manager GET:serverurl parameters:questionDict progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if(completionBlock){
            if (completionBlock) {
                completionBlock(responseObject,nil);
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(completionBlock) {
            completionBlock(nil,error);
        }
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:serverurl parameters:questionDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(completionBlock){
//            completionBlock(responseObject,nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if(completionBlock) {
//            completionBlock(nil,error);
//        }
//        NSString* string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
//        if (string!=nil) {
//            NSLog(@"%@",string);
//        }
//    }];
}
-(void)generalNetwork:(NSString*)serverurl Data:(NSDictionary*)questionDict withCompletionBlock:(NetworkCompletionBlock)completionBlock{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([[serverurl lowercaseString] hasPrefix:@"https://"]) {
        manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    
    
    
    [manager GET:serverurl parameters:questionDict progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if(completionBlock){
            if ([self checkResponse:responseObject] && completionBlock) {
                completionBlock(responseObject,nil);
            }else{
                completionBlock(responseObject,[[NSError alloc] init]);
            }
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(completionBlock) {
            completionBlock(nil,error);
        }
        
    }];
}
- (void)uploadImageToServer:(NSData*)data FileName:(NSString*)fileName ApiPath:(NSString*)apiPath Mode:(int)whichserver withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSString *serverurl = GlobalSwift.g_baseUrl ;
    switch(whichserver) {
        case 1:
            serverurl = GlobalSwift.g_baseUrl2;
            break;
        default:
            
            break;
    }
    serverurl = [serverurl stringByAppendingString:apiPath];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([[serverurl lowercaseString] hasPrefix:@"https://"]) {
        manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    
    
    [manager POST:serverurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"uploaded_file" fileName:fileName mimeType:@"multipart/form-data;boundary=*****"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"Success: %@", responseObject);
        if(completionBlock){
            if ([self checkResponse:responseObject]) {
                
                completionBlock(responseObject,nil);
            }else{
                completionBlock(nil,[[NSError alloc] init]);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errResponse);
        if(completionBlock) {
            completionBlock(nil,error);
        }
    }];
}
- (void)uploadImage:(NSData*)data FileName:(NSString*)fileName ApiPath:(NSString*)apiPath withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    
    
    NSString *serverurl = GlobalSwift.g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:apiPath];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([[serverurl lowercaseString] hasPrefix:@"https://"]) {
        manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    
    
    [manager POST:serverurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"uploaded_file" fileName:fileName mimeType:@"multipart/form-data;boundary=*****"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"Success: %@", responseObject);
        if(completionBlock){
            if ([self checkResponse:responseObject]) {
                
                completionBlock(responseObject,nil);
            }else{
                completionBlock(nil,[[NSError alloc] init]);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errResponse);
        if(completionBlock) {
            completionBlock(nil,error);
        }
    }];
    
    
    
    
//    [manager POST:serverurl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:fileName mimeType:@"multipart/form-data;boundary=*****"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        if(completionBlock){
//            if ([self checkResponse:responseObject]) {
//                
//                completionBlock(responseObject,nil);
//            }else{
//                completionBlock(nil,[[NSError alloc] init]);
//            }
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        if(completionBlock) {
//            completionBlock(nil,error);
//        }
//    }];
    
    
}
- (void)uploadVideo:(NSString*)fileName ApiPath:(NSString*)apiPath FileURL:(NSURL*)fileURL withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    
    NSString *serverurl = GlobalSwift.g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:apiPath];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:serverurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileURL name:@"uploaded_file" fileName:fileName mimeType:@"video/mp4" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          if(completionBlock){
                              if ([self checkResponse:responseObject]) {
                                  
                                  completionBlock(responseObject,nil);
                              }else{
                                  completionBlock(nil,[[NSError alloc] init]);
                              }
                              
                          }
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          if(completionBlock) {
                              completionBlock(nil,error);
                          }
                      }
                  }];
    
    [uploadTask resume];
}
-(void)ontemplateGeneralRequest:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = GlobalSwift.g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:url];
    
    NSMutableDictionary *questionDict=nil;
    if (data!=nil) {
        questionDict=[BaseModel getQuestionDict:data];
        NSLog(@"Dictionary = %@",questionDict);
        NSLog(@"Url = %@",url);
    }
    
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}
-(void)ontemplateRequestWithNoCheck:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = GlobalSwift.g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:url];
    
    NSMutableDictionary *questionDict=nil;
    if (data!=nil) {
        questionDict=[BaseModel getQuestionDict:data];
    }
    
    [self generalNetworkWithNoCheck:serverurl Data:questionDict withCompletionBlock:completionBlock];
}

-(void)ontemplateGeneralRequestWithRawUrl:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = url ;
    
    NSMutableDictionary *questionDict=nil;
    if (data!=nil) {
        questionDict=[BaseModel getQuestionDict:data];
    }
    
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}
-(void)ontemplateGeneralRequestWithRawUrlNoCheck:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = url ;
    
    NSMutableDictionary *questionDict=nil;
    if (data!=nil) {
        questionDict=[BaseModel getQuestionDict:data];
    }
    
    
    [self generalNetworkWithNoCheck:serverurl Data:questionDict withCompletionBlock:completionBlock];
}


@end











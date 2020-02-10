//
//  ServiceManager.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 16/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ServiceManager.h"
#import "AFNetworking.h"
//#import "AttachmentViewModel.h"

@implementation ServiceManager

//MARK:- Shared manager method

+ (ServiceManager *)sharedManager {
    static ServiceManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


//MARK:- Initialization methods

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


//MARK:- Get webservice methods

-(void)callWebServiceWithGet:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params{
    
    NSURLComponents *components = [NSURLComponents componentsWithString:webpath];
    NSMutableArray *arrQueryItems = [NSMutableArray new];
    for(NSDictionary *dic in params){
        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:[dic allKeys][0] value:[dic allValues][0]];
        [arrQueryItems addObject:queryItem];
    }
    components.queryItems = arrQueryItems;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    //serializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    
    //    [serializer setValue: @"application/json" forKey: @"Content-Type"];
    
    //[serializer setAcceptableContentTypes: [NSSet setWithObject: @"application/json"]];
    
    //    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //NSSet(array: ["application/xml", "text/xml", "text/plain"]);
    
    //    manager.responseSerializer = serializer;
    
    NSURL *URL = components.URL;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //NSMutableURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:webpath parameters: nil error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
                [self.delegate webServiceCallFailure:error forTag:tagname];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
                
                NSError *err;
                id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                if(err){
                    NSLog(@"Error : %@", err.localizedDescription);
                    NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"Response : %@", strResponse);
                }
                
                [self.delegate webServiceCallSuccess: responseFromServer forTag:tagname];
            }
        }
        
    }];
    
    //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
    //                [self.delegate webServiceCallFailure:error forTag:tagname];
    //            }
    //        } else {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
    //                [self.delegate webServiceCallSuccess:responseObject forTag:tagname];
    //            }
    //        }
    //    }];
    [dataTask resume];
}


//MARK:- Post webservice methods

-(void)callWebServiceWithPOST:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    //    if (([tagname isEqualToString: @"SearchList"]) && ([params count] == 1)) {
    //
    //        parameters = params[0];
    //
    //    } else {
    
    for(NSDictionary *currentDic in params){
        if ([[currentDic allKeys] containsObject: @"place_name"]) {
            if ([[currentDic valueForKey: @"place_name"] containsString: @"\u2019"]) {
                NSString *s = [currentDic valueForKey: @"place_name"];
                s = [s stringByReplacingOccurrencesOfString: @"\u2019" withString: @"'"];
                
            }
        }
        [parameters addEntriesFromDictionary: currentDic];
    }
    
    NSLog(@"\n%@", webpath);
    NSLog(@"%@\n", parameters);
    
    //    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:webpath parameters:parameters error:nil];
    request.timeoutInterval = 180;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
                [self.delegate webServiceCallFailure:error forTag:tagname];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
                NSError *err;
                id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                if(err){
                    NSLog(@"Error : %@", err.localizedDescription);
                    NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"Response : %@", strResponse);
                }
                [self.delegate webServiceCallSuccess:responseFromServer forTag:tagname];
            }
        }
        
    }];
    
    //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
    //                [self.delegate webServiceCallFailure:error forTag:tagname];
    //            }
    //        } else {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
    //                NSError *err;
    //                id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
    //                if(err){
    //                    NSLog(@"Error : %@", err.localizedDescription);
    //                    NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //                    NSLog(@"Response : %@", strResponse);
    //                }
    //                [self.delegate webServiceCallSuccess:responseFromServer forTag:tagname];
    //            }
    //        }
    //    }];
    [dataTask resume];
}

- (void) callWebServiceWithPOST: (NSString *) webpath withTag: (NSString *) tagname paramsDic: (NSDictionary *) params {
    
    NSLog(@"\n%@", webpath);
    NSLog(@"%@\n", params);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:webpath parameters: [params mutableCopy] error:nil];
    request.timeoutInterval = 180;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
                [self.delegate webServiceCallFailure:error forTag:tagname];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
                NSError *err;
                id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                if(err){
                    NSLog(@"Error : %@", err.localizedDescription);
                    NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"Response : %@", strResponse);
                }
                [self.delegate webServiceCallSuccess:responseFromServer forTag:tagname];
            }
        }
        
    }];
    
    //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
    //                [self.delegate webServiceCallFailure:error forTag:tagname];
    //            }
    //        } else {
    //            if ([self.delegate respondsToSelector:@selector(webServiceCallSuccess:forTag:)]) {
    //                NSError *err;
    //                id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
    //                if(err){
    //                    NSLog(@"Error : %@", err.localizedDescription);
    //                    NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //                    NSLog(@"Response : %@", strResponse);
    //                }
    //                [self.delegate webServiceCallSuccess:responseFromServer forTag:tagname];
    //            }
    //        }
    //    }];
    [dataTask resume];
}

- (void)callWebServiceWithPOSTForImageUpload:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params imgArray:(NSMutableArray *)arrImages {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for(NSDictionary *currentDic in params){
        [parameters addEntriesFromDictionary:currentDic];
    }
    
    NSLog(@"\n%@", webpath);
    NSLog(@"%@\n", parameters);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:webpath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i = 0; i < [arrImages count]; i++){
            
//            AttachmentViewModel *attachmentModel = arrImages[i];
//            UIImage *img = attachmentModel.Image;
//            NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
//            NSString *name = attachmentModel.ImageFileName;
            
            /* NSData *imgData = UIImageJPEGRepresentation(img, 0.8);
             UIImage *compressedImage = [UIImage imageWithData:imgData];
             compressedImage = [compressedImage fixOrientation];
             [formData appendPartWithFileData:UIImagePNGRepresentation(compressedImage) name:name@"uploadedfile" fileName:name mimeType:@"image/png"]; */
            NSData *imgData = UIImageJPEGRepresentation(arrImages[0], 1.0);
            NSString *newName = [@"profile_pic" stringByAppendingString:@".jpg"];
            [formData appendPartWithFileData:imgData name:@"profile_pic" fileName:newName mimeType:@"image/png"];
            
        }
        
        NSLog(@"%@", formData);
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //Update the progress view
                                                  NSLog(@"Completed : %f", uploadProgress.fractionCompleted);
                                              });
                                          }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              if (error) {
                                                  if ([self.delegate respondsToSelector:@selector(webServiceCallFailure:forTag:)]) {
                                                      [self.delegate webServiceCallFailure:error forTag:tagname];
                                                  }
                                              } else {
                                                  NSError *err;
                                                  id responseFromServer = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                                                  if(err){
                                                      NSLog(@"Error : %@", err.localizedDescription);
                                                      NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                      NSLog(@"Response : %@", strResponse);
                                                  }
                                                  [self.delegate webServiceCallSuccess:responseFromServer forTag:tagname];
                                              }
                                              
                                          }];
    
    [uploadTask resume];
}

@end

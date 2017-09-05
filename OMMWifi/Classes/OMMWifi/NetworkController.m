

//
//  NetworkController.m
//  Copyright © 2017 onmymobile. All rights reserved.
//

#define GET_REQUEST @"GET"
#define POST_REQUEST @"POST"
#define CONTENT_XFORM @"application/x-www-form-urlencoded"
#define CONTENT_JSON @"application/json"


#import "NetworkController.h"

@implementation NetworkController


/**
 Network Shared Instance

 @return Instance (Singleton)
 */
+ (id)sharedInstance {
    static NetworkController *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}



/**
 Network GET Request Method

 @param url        HTTP Url
 @param params     Parameter in dictionary
 @param completion Response data & error
 */
- (void)GETRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withContentType:(NSString*)contentType  withCompletionBlock:(void(^)(id response, NSError *error))completion {
    
    [[NetworkController sharedInstance] baseRequestWithUrl:url withParameters:params withHTTPMethod:GET_REQUEST withContentType:contentType withCompletionBlock:^(id response, NSError *error) {
        completion(response, error);
    }];
}



/**
 Network POST Request Method
 
 @param url        HTTP Url
 @param params     Parameter in dictionary
 @param completion Response data & error
 */
- (void)POSTRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withContentType:(NSString*)contentType withCompletionBlock:(void(^)(NSData *response, NSError *error))completion {
    
    [[NetworkController sharedInstance] baseRequestWithUrl:url withParameters:params withHTTPMethod:POST_REQUEST withContentType:contentType withCompletionBlock:^(NSData *returnData, NSError *error) {
       completion(returnData, error);
    }];
}



/**
 Base request method for all HTTP requests (GET, POST...)

 @param url        HTTP Url
 @param params     Parameter in dictionary
 @param method     Base request method
 @param completion Response data & error
 */
//- (void)baseRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withHTTPMethod:(NSString*)method withContentType:(NSString*)contentType withCompletionBlock:(void(^)(id data, NSError *error))completion {
//    
//    NSError *error;
//    NSData *postData;
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:60.0];
//    
//    [request setHTTPMethod:method];
//    
//    if (params) {
//    if ([contentType isEqualToString:CONTENT_XFORM]) {
//        [request addValue:CONTENT_XFORM forHTTPHeaderField:@"Content-Type"];
//        postData = [[NetworkController sharedInstance] httpBodyForParameters:params];
//        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
//    }
//    
//    if ([contentType isEqualToString:CONTENT_JSON]) {
//            [request addValue:CONTENT_JSON forHTTPHeaderField:@"Content-Type"];
//            [request addValue:CONTENT_JSON forHTTPHeaderField:@"Accept"];
//            postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
//    }
//    
//    [request setHTTPBody:postData];
//    }
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        if (error) {
//            //NSLog(@"Error Response - %@", error.localizedDescription);
//            completion(nil, error);
//            return;
//        }
//        
//        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
//            if (statusCode != 200) {
//                //NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
//            }
//        }
//        
//        if (error == nil) {
//            //NSLog(@"Data - %@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
//            //NSLog(@"Response - %@", response);
//            
//            NSError *jsonError;
//            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
//            
//            if ([jsonData isKindOfClass:[NSDictionary class]]) {
//                    completion(jsonData, nil);
//                    return;
//            }
//            
//            completion([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding], nil);
//        }
//    }];
//    
//    [dataTask resume];
//}

- (void)baseRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withHTTPMethod:(NSString*)method withContentType:(NSString*)contentType withCompletionBlock:(void(^)(NSData *returnData, NSError *error))completion {
    
    NSError *error;
    NSData *postData;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:method];
    
    if (params) {
        if ([contentType isEqualToString:CONTENT_XFORM]) {
            [request addValue:CONTENT_XFORM forHTTPHeaderField:@"Content-Type"];
            postData = [self httpBodyForParameters:params];
            [request setValue:[NSString stringWithFormat:@"%d", (int)[postData length]] forHTTPHeaderField:@"Content-Length"];
        }
        
        if ([contentType isEqualToString:CONTENT_JSON]) {
            [request addValue:CONTENT_JSON forHTTPHeaderField:@"Content-Type"];
            [request addValue:CONTENT_JSON forHTTPHeaderField:@"Accept"];
            postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        }
        
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        if (error) {
            NSLog(@"Error Response - %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        
        if (error == nil) {
            //NSLog(@"Data - %@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
            //NSLog(@"Response - %@", response);
//            
//            NSError *jsonError;
//            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
//            
//            if ([jsonData isKindOfClass:[NSDictionary class]]) {
//                completion(jsonData, nil);
//                return;
//            }
            
            completion(data, nil);
            
        }
    }];
    
    [dataTask resume];
}

    
/** Build the body of a `application/x-www-form-urlencoded` request from a dictionary of keys and string values
 
 @param parameters The dictionary of parameters.
 @return The `application/x-www-form-urlencoded` body of the form `key1=value1&key2=value2`
 */
- (NSData *)httpBodyForParameters:(NSDictionary *)parameters {
    
    NSMutableArray *parameterArray = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", [self percentEscapeString:key], [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


/** Percent escapes values to be added to a URL query as specified in RFC 3986.
  
 See http://www.ietf.org/rfc/rfc3986.txt
 
 @param string The string to be escaped.
 @return The escaped string.
 */
- (NSString *)percentEscapeString:(NSString *)string {
    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"];
    NSLog(@"%@",string);
    NSLog(@"%@",allowed);
    NSLog(@"%@",[string stringByAddingPercentEncodingWithAllowedCharacters:allowed]);
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}


- (NSError*)createError:(NSString*)domain andLocalDescription:(NSString*)localDescription{
    NSMutableDictionary* details = [NSMutableDictionary new];
    [details setValue:localDescription forKey:NSLocalizedDescriptionKey];
    // populate the error object with the details
    NSError *error = [NSError errorWithDomain:domain code:200 userInfo:details];
    return error;
}


@end

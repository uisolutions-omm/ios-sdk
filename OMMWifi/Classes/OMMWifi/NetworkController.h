

//
//  NetworkController.m
//  Copyright © 2017 onmymobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+ (id)sharedInstance;
- (void)GETRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withContentType:(NSString*)contentType withCompletionBlock:(void(^)(id response, NSError *error))completion;
//- (void)POSTRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withContentType:(NSString*)contentType withCompletionBlock:(void(^)(id response, NSError *error))completion;
- (void)POSTRequestWithUrl:(NSURL*)url withParameters:(NSDictionary*)params withContentType:(NSString*)contentType withCompletionBlock:(void(^)(NSData *response, NSError *error))completion;
- (NSError*)createError:(NSString*)domain andLocalDescription:(NSString*)localDescription;
    
@end

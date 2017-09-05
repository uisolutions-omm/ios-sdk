
//
//  BranchAPIController.m
//  Copyright © 2017 onmymobile. All rights reserved.
//


#define GET_REQUEST @"GET"
#define POST_REQUEST @"POST"
#define CONTENT_XFORM @"application/x-www-form-urlencoded"
#define CONTENT_JSON @"application/json"

#import "BranchAPIController.h"
#import "NetworkController.h"
#import "Config.h"

@implementation BranchAPIController


/**
 Network Shared Instance
 
 @return Instance (Singleton)
 */
+ (id)sharedInstance {
    static BranchAPIController *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}



/**
 Creating a branch link

 @param channelType Email/Facebook ...
 @param username    username
 @param email       email
 @param userId      userId
 @param urlType     Desktop/Android/iOS ...
 @param url         redirect url
 @param completion  call back after completion of the request
 */
- (void)createBranchLinkWithChannelType:(NSString*)channelType
                             username:(NSString*)username
                                email:(NSString*)email
                               userId:(NSString*)userId
                              urlType:(NSString*)urlType
                                  url:(NSString*)url
                       withCompletion:(void (^) (NSString *link))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/url", [[Config getInstance] BRANCH_BASE_URL]];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    //NSString *chnlType = [[NetworkController sharedInstance] channelType:channelType];
    //NSString *branchUrlType = [[NetworkController sharedInstance] urlType:urlType];
    
    NSDictionary *params =
    @{  @"branch_key": [[Config getInstance] BRANCH_KEY],
        @"campaign": [[Config getInstance] BRANCH_CAMPAIGN],
        @"channel": channelType,
        @"data": @{
            @"name": username,
            @"email": email,
            @"user_id": userId,
            urlType: url
        }
    };
    
    [[NetworkController sharedInstance] POSTRequestWithUrl:requestUrl withParameters:params withContentType:CONTENT_JSON withCompletionBlock:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSString *createdUrl = [response valueForKey:@"url"];
            completion(createdUrl);
        }else{
            completion(@"Create link failed");
        }
    }];
}


- (void)viewStateOfDeepLinkingUrl:(NSString*)url withCompletion:(void (^) (NSDictionary *response))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/url?url=%@&branch_key=%@", [[Config getInstance] BRANCH_BASE_URL], url, [[Config getInstance] BRANCH_KEY]];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    [[NetworkController sharedInstance] GETRequestWithUrl:requestUrl withParameters:nil withContentType:CONTENT_JSON withCompletionBlock:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"-----------> Get Link Status %@", response);
            //NSString *createdUrl = [response valueForKey:@"url"];
            //completion(createdUrl);
            
            /*{
                "channel": "twitter",
                "campaign": "twitter-november-campaign",
                "feature": "share-button",
                "data": {
                    "photo_id": "51",
                    "valid": "true",
                    "photo_name": "John Smith",
                    "$og_image_url": "https://imgur.com/abcd",
                    "~id": "123456789",
                    "url": "https://bnc.lt/test-link"
                },
                "alias": "test-link",
                "type": 0
            }*/
        }else{
            
        }
    }];
}


- (void)getCreditsCountsWithIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/credits?branch_key=%@&identity=%@", [[Config getInstance] BRANCH_BASE_URL], [[Config getInstance] BRANCH_KEY], identity];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    [[NetworkController sharedInstance] GETRequestWithUrl:requestUrl withParameters:nil withContentType:CONTENT_JSON withCompletionBlock:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"-----------> Get Credits Count %@", response);
            //NSString *createdUrl = [response valueForKey:@"url"];
            //completion(createdUrl);
            
            /*{
             'default': 15,
             'other bucket': 4
             }*/
        }else{
            
        }
    }];
    
}

- (void)addCreditsWithAmount:(NSString*)amount andIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/credits", [[Config getInstance] BRANCH_BASE_URL]];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSDictionary *params = @{
                             @"branch_key":[[Config getInstance] BRANCH_KEY],
                             @"branch_secret":[[Config getInstance] BRANCH_SECRET],
                             @"identity":identity,
                             @"amount":amount
                             };
    
    [[NetworkController sharedInstance] POSTRequestWithUrl:requestUrl withParameters:params withContentType:CONTENT_JSON withCompletionBlock:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSLog(@"-----------> Added Credits Response %@", response);
        }else{
            
        }
    }];
}

- (void)redeemCreditsWithAmount:(NSString*)amount andIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/redeem", [[Config getInstance] BRANCH_BASE_URL]];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSDictionary *params = @{
                             @"branch_key":[[Config getInstance] BRANCH_KEY],
                             @"branch_secret":[[Config getInstance] BRANCH_SECRET],
                             @"identity":identity,
                             @"amount":amount
                             };
    
    [[NetworkController sharedInstance] POSTRequestWithUrl:requestUrl withParameters:params withContentType:CONTENT_JSON withCompletionBlock:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSLog(@"-----------> redeem Credits Response %@", response);
        }else{
            
        }
    }];
}

@end

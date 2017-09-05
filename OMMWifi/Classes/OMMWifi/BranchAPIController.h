
//
//  BranchAPIController.h
//  Copyright © 2017 onmymobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchAPIController : NSObject

+ (id)sharedInstance;
- (void)createBranchLinkWithChannelType:(NSString*)channelType
                               username:(NSString*)username
                                  email:(NSString*)email
                                 userId:(NSString*)userId
                                urlType:(NSString*)urlType
                                    url:(NSString*)url
                         withCompletion:(void (^) (NSString *link))completion;

- (void)viewStateOfDeepLinkingUrl:(NSString*)url withCompletion:(void (^) (NSDictionary *response))completion;
- (void)getCreditsCountsWithIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion;
- (void)addCreditsWithAmount:(NSString*)amount andIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion;
- (void)redeemCreditsWithAmount:(NSString*)amount andIdentity:(NSString*)identity withCompletion:(void (^) (NSDictionary *response))completion;

@end

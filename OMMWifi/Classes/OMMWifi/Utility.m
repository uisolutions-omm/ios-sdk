//
//  Utility.m
//  OMMWifi
//
//  Created by Apple on 23/03/17.
//  Copyright © 2017 onmymobile. All rights reserved.
//



#import "OMMWifiAPIController.h"
#import "NetworkController.h"
#import "FirebaseAPIController.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import "Branch.h"
#import "Utility.h"
#import "Firebase.h"
#import <MessageUI/MessageUI.h>
#import <CleverTapSDK/CleverTap.h>
#import "Config.h"
#define LOCATION_COVER_DISTANCE @"200"


#define UTIL_COUPON_KEY @"UTIL_COUPON_KEY"
#define UTIL_MOBILE_NUMBER_KEY @"UTIL_MOBILE_NUMBER_KEY"
#define UTIL_BRANCH_PARAMS_KEY @"UTIL_BRANCH_PARAMS_KEY"
#define UTIL_ISDELAYEDCOUPON_KEY @"UTIL_ISDELAYEDCOUPON_KEY"
#define UTIL_ISREDEEMEDCOUPON_KEY @"UTIL_ISREDEEMEDCOUPON_KEY"


#import "Utility.h"
#import "Reachability.h"


@implementation Utility


+ (void)setCoupon:(NSString *)coupon{
    [[NSUserDefaults standardUserDefaults] setValue:coupon forKey:UTIL_COUPON_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*)getCoupon{
    NSString *coupon = [[NSUserDefaults standardUserDefaults] valueForKey:UTIL_COUPON_KEY];
    if (coupon) {
        return coupon;
    }else{
        return @"";
    }
}


+ (void)setMobileNumber:(NSString *)mobNum{
    [[NSUserDefaults standardUserDefaults] setValue:mobNum forKey:UTIL_MOBILE_NUMBER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*)getMobileNumber{
    NSString *mobNum = [[NSUserDefaults standardUserDefaults] valueForKey:UTIL_MOBILE_NUMBER_KEY];
    
    if (mobNum) {
        return mobNum;
    }else{
        return @"";
    }
}


+ (void)setDelayedCouponEligibility:(BOOL)isEligible{
    [[NSUserDefaults standardUserDefaults] setBool:isEligible forKey:UTIL_ISDELAYEDCOUPON_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (BOOL)getDelayedCouponEligibility{
    
    BOOL isEligible = [[NSUserDefaults standardUserDefaults] boolForKey:UTIL_ISDELAYEDCOUPON_KEY];
    return isEligible;
    
}


+ (void)setCouponRedeemedStatus:(BOOL)isRedeemed{
    
    [[NSUserDefaults standardUserDefaults] setBool:isRedeemed forKey:UTIL_ISREDEEMEDCOUPON_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)getCouponRedeemedStatus{
    
    BOOL isRedeemed = [[NSUserDefaults standardUserDefaults] boolForKey:UTIL_ISREDEEMEDCOUPON_KEY];
    return isRedeemed;
}


+ (void)setBranchParams:(NSDictionary *)params{
    [[NSUserDefaults standardUserDefaults] setValue:params forKey:UTIL_BRANCH_PARAMS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSDictionary *)getBranchParams{
    
    NSDictionary *params = [[NSUserDefaults standardUserDefaults] valueForKey:UTIL_BRANCH_PARAMS_KEY];
    
    if (params) {
        return params;
    }else{
        return @{};
    }
}



+(BOOL)isInternetConnectionExists
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [Reachability reachabilityWithHostName:@"www.apple.com"];    // set your host name here
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}



+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message WithCompletion:(void (^)(BOOL isSuccess))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        if (block) {
            block(YES);
        }
    }];
    [alert addAction:okAction];
    [[[[[UIApplication sharedApplication]delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end

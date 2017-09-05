
//
//  FirebaseAPIController.m
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

// Screen Dimension
#define SCREEN_WIDTH [[[UIScreen mainScreen] bounds] size].width
#define SCREEN_HEIGHT [[[UIScreen mainScreen] bounds] size].height
#define SCREEN_CENTER_X @""
#define SCREEN_CENTER_Y @""


// Error Logs
#define ENTER_VALID_MOB_NUM @"Please enter 10-digit valid mobile number"
#define NETWORK_ERROR @"Network Error"
#define NETWORK_ERROR_TRY_AGAIN @"Network Error. Please try again after a while"
#define OMMWIFI_ERROR @"OMMWifi Error"


// Commons
#define COUNTRY_CODE @"91"

#define APP_NAME @"appName"
#define ARRAY_KEY @"array"
#define MOBILE @"mobile"

#define RESPONSE_INVALID_VOUCHER @"Not valid voucher."
#define RESPONSE_VALID_VOUCHER @"Success"

#define USERS_KEY @"users"
#define TEST_KEY @"test"
#define NAME_KEY @"name"
#define VOUCHERS_KEY @"vouchers"
#define WIFI_KEY @"wifi"
#define SHOPS_KEY @"shops"
#define SHOP1_KEY @"shop1"
#define INCENTIVE_COUPONS_KEY @"incentiveCoupons"
#define ISREDEEMED_KEY @"isRedeemed"
#define DELAYED_COUPONS_KEY @"DelayedCoupons"
#define LOCATION_VALIDATED @"LOCATION_VALIDATED"

#define UTIL_COUPON_KEY @"UTIL_COUPON_KEY"
#define UTIL_MOBILE_NUMBER_KEY @"UTIL_MOBILE_NUMBER_KEY"
#define UTIL_BRANCH_PARAMS_KEY @"UTIL_BRANCH_PARAMS_KEY"
#define UTIL_ISDELAYEDCOUPON_KEY @"UTIL_ISDELAYEDCOUPON_KEY"
#define UTIL_ISREDEEMEDCOUPON_KEY @"UTIL_ISREDEEMEDCOUPON_KEY"


#define BRANCH_MOBILE_NUMBER_KEY @"mobileNumber"
#define IS_WIFI_SCHEME_KEY @"isWifiScheme"
#define IS_CHECKINNOW_KEY @"isCheckInNow"

// HTTP Requests
#define GET_REQUEST @"GET"
#define POST_REQUEST @"POST"
#define CONTENT_XFORM @"application/x-www-form-urlencoded"
#define CONTENT_JSON @"application/json"

#define ERROR_MSG_001 @"Already Redeemed !"
#define ERROR_MSG_002 @"Please enter valid params"
#define ERROR_MSG_003 @"Currently coupons are unavailable !"
#define ERROR_MSG_004 @"Not a valid vocher"
#define ERROR_MSG_005 @"UnExpectedError"
#define ERROR_MSG_006 @"Please register your mobile number with BSNL"
#define ERROR_MSG_007 @"Invalid secret code"
#define ERROR_MSG_008 @"Success"
#define ERROR_MSG_009 @"Some Error"


#import "FirebaseAPIController.h"
#import "NetworkController.h"
#import "Firebase.h"
#import "Config.h"
#import "OMMWifiAPIController.h"

@implementation FirebaseAPIController

+ (id)sharedInstance {
    static FirebaseAPIController *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        [FirebaseAPIController initialiseFirebase];
    });
    return sharedMyInstance;
}


+ (void)initialiseFirebase{
    FIROptions *options = [[FIROptions alloc] initWithGoogleAppID:[[Config getInstance] GOOGLE_APP_ID] bundleID:[[Config getInstance] BUNDLE_ID] GCMSenderID:[[Config getInstance] GCM_SENDER_ID] APIKey:[[Config getInstance] API_KEY] clientID:[[Config getInstance] CLIENT_ID] trackingID:[[Config getInstance] TRACKING_ID] androidClientID:[[Config getInstance] ANDROID_CLIENT_ID] databaseURL:[[Config getInstance] DATABASE_URL] storageBucket:[[Config getInstance] STORAGE_BUCKET] deepLinkURLScheme:[[Config getInstance] DEEP_LINK_URL_SCHEME]];
    
    [FIRApp configureWithName:@"sdkproject" options:options];
}


- (void)saveNameToFB:(NSString*)name{
    [[[[FIRDatabase databaseForApp:[FIRApp appNamed:@"sdkproject"]] reference] child: TEST_KEY] setValue:@{@"name": NAME_KEY}];
}


- (void)signUpFirebase:(NSString*)mobileNumber withCompletion:(void (^) (NSString *uid, NSError *anError))completion {
    
    NSString *email = [NSString stringWithFormat:@"%@@tollyteaser.com", mobileNumber];
    
    [[FIRAuth authWithApp:[FIRApp appNamed:@"sdkproject"]] signInWithEmail:email password:mobileNumber completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error == nil) {
            completion(user.uid, error);
            return;
        }
        
        if (error) {
            [[FIRAuth authWithApp:[FIRApp appNamed:@"sdkproject"]] createUserWithEmail:email password:mobileNumber completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                NSLog(@"FIR UID ------> %@", user.uid);
                if (error == nil) {
                    completion(user.uid, error);
                }else{
                    completion(@"", error);
                }
            }];
        }
    }];
    
//    [[FIRAuth auth] createUserWithEmail:email password:mobileNumber completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//        NSLog(@"FIR UID ------> %@", user.uid);
//        completion(user.uid, error);
//    }];
}


- (void)getVoucher:(void (^) (NSString *vPin, NSString *sid, NSError *error))completion {
    [[[[[[FIRDatabase database]reference] child: VOUCHERS_KEY] queryOrderedByChild: ISREDEEMED_KEY]
      queryEqualToValue: @NO] observeSingleEventOfType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *sid = snapshot.key;
        
        if (snapshot.value != [NSNull null]){
            if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictVoucher = snapshot.value;
                NSLog(@"NETWORK LOG HERE --- %@", sid);
                completion([dictVoucher valueForKey: [[Config getInstance] VPIN_KEY]], sid, nil);
                return;
            }
        }else{
            NSError *err = [[NetworkController sharedInstance] createError:@"OMMWifi Error" andLocalDescription:NETWORK_ERROR];
            completion(nil, nil, err);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        completion(nil, nil, error);
    }];

}


/*- (void)getUserCouponDetailsWithCompletion:(void (^) (NSString *uid, NSString *coupon, NSString *mobileNumber, BOOL status))completion {
    if ([[FIRAuth auth] currentUser] == nil) {
        return;
    }
    
    [[[[[FIRDatabase database]reference] child:@"wifi"] child:[[FIRAuth auth] currentUser].uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //NSLog(@"Check Coupon Redeem Status -----> %@", [[[snapshot value] allValues] valueForKey:@"isRedeemed"]);
        
        BOOL status = [[[snapshot value] allValues] valueForKey:@"isRedeemed"];
        completion([[FIRAuth auth] currentUser].uid, [[[snapshot value] allValues] valueForKey:@"couponNumber"], [[[snapshot value] allValues] valueForKey:@"phoneNumber"], status);
    }];
}*/

- (void)getUserCouponDetailsWithCoupon:(NSString*)coupon andCompletion:(void (^) (NSString *uid, NSString *coupon, NSString *mobileNumber, BOOL status))completion {
    if ([[FIRAuth auth] currentUser] == nil) {
        return;
    }
    
    [[[[[FIRDatabase database]reference] child: INCENTIVE_COUPONS_KEY] child: coupon] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        //NSLog(@"-------->%@",[[snapshot.value valueForKey:@"isRedeemed"] stringValue]);
        
        if ([[[snapshot.value valueForKey:@"isRedeemed"] stringValue] isEqualToString:@"0"]) {
            [[[[[FIRDatabase database]reference] child: INCENTIVE_COUPONS_KEY] child: coupon] updateChildValues:@{@"isRedeemed":@YES}];
            completion([[FIRAuth auth] currentUser].uid, [snapshot.value valueForKey:@"couponNumber"], [snapshot.value valueForKey:@"phoneNumber"], YES);
            return;
        }else{
            completion(nil, nil, nil, NO);
            return;
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        //completion(NO);
    }];
}


/*- (void)markVoucherAsRedeemedWithSID:(NSString*)sid {
    NSDictionary *post = @{ ISREDEEMED_KEY: @YES
                           };
    [[[[[FIRDatabase database]reference] child: VOUCHERS_KEY] child:sid] updateChildValues:post];
}*/


- (void)initialiseRedemptionWithUID:(NSString*)userId Coupon:(NSString*)aCoupon MobileNumber:(NSString*)aMobileNumber {
    NSDictionary *post = @{ ISREDEEMED_KEY: @YES
                            };
    [[[[[FIRDatabase database]reference] child: WIFI_KEY] child:[[FIRAuth auth] currentUser].uid] updateChildValues:post];
    [[FirebaseAPIController sharedInstance] updateShopKeeper:userId Coupon:aCoupon MobileNumber:aMobileNumber];
    
}


- (void)updateShopKeeper:(NSString*)userId Coupon:(NSString*)aCoupon MobileNumber:(NSString*)aMobileNumber {
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"uid",aCoupon,@"couponNumber",aMobileNumber,@"phoneNumber", nil];
    
    [[[[[[FIRDatabase database]reference] child: SHOPS_KEY] child: SHOP1_KEY] childByAutoId] setValue:dictParams];
}


- (void)validateCouponsInFirebaseWithCoupon:(NSString*)coupon withCompletion:(void (^) (BOOL isSuccess))completion {
    
    [[[[[FIRDatabase database]reference] child: INCENTIVE_COUPONS_KEY] child: coupon] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"-------->%@",[[snapshot.value valueForKey:@"isRedeemed"] stringValue]);
        
        if ([[[snapshot.value valueForKey:@"isRedeemed"] stringValue] isEqualToString:@"0"]) {
            [[[[[FIRDatabase database]reference] child: INCENTIVE_COUPONS_KEY] child: coupon] updateChildValues:@{@"isRedeemed":@YES}];
            completion(YES);
            return;
        }else{
            completion(NO);
            return;
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        //completion(NO);
    }];
    
    
}


- (void)getLocationsFromFirebaseWithCompletion:(void (^) (NSArray *locations))completion{
    
    //[[[[FIRDatabase database]reference] child: LOCATIONS_KEY] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
    //}];
    
}


- (void)saveDelayedCouponEntry{
    
    NSNumber *time = [NSNumber numberWithLongLong:(long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
    
    NSDictionary *params = @{
                             @"isRedeemed":@NO,
                             @"time":time
                             };
    
    [[[[[[FIRDatabase database]reference] child: DELAYED_COUPONS_KEY] child:@"userId"] childByAutoId] setValue:params];
    
}


- (void)testIntegration{
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    bundleID = [bundleID stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    [[[[[[FIRDatabase databaseForApp:[FIRApp appNamed:@"sdkproject"]] reference] child: @"IntegratedApps"] child:bundleID] child:@"ios"] setValue: @"done"];
}
@end

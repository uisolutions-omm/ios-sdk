
//
//  FirebaseAPIController.m
//  Copyright © 2017 onmymobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FirebaseAPIController : NSObject

+ (id)sharedInstance;
- (void)saveNameToFB:(NSString*)name;
- (void)getVoucher:(void (^) (NSString *vPin, NSString *sid, NSError *error))completion;
- (void)markVoucherAsRedeemedWithSID:(NSString*)sid;
- (void)initialiseRedemptionWithUID:(NSString*)userId Coupon:(NSString*)aCoupon MobileNumber:(NSString*)aMobileNumber;
- (void)signUpFirebase:(NSString*)mobileNumber withCompletion:(void (^) (NSString *uid, NSError *anError))completion;
- (void)getUserCouponDetailsWithCoupon:(NSString*)coupon andCompletion:(void (^) (NSString *uid, NSString *coupon, NSString *mobileNumber, BOOL status))completion;

- (void)validateCouponsInFirebaseWithCoupon:(NSString*)coupon withCompletion:(void (^) (BOOL isSuccess))completion;

- (void)getLocationsFromFirebaseWithCompletion:(void (^) (NSArray *locations))completion;
- (void)saveDelayedCouponEntry;
- (void)testIntegration;

@end

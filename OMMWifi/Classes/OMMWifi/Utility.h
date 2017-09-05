//
//  Utility.h
//  OMMWifi
//
//  Created by Apple on 23/03/17.
//  Copyright © 2017 onmymobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (void)setCoupon:(NSString*)coupon;
+ (NSString*)getCoupon;

+ (void)setMobileNumber:(NSString*)mobNum;
+ (NSString*)getMobileNumber;


+ (void)setBranchParams:(NSDictionary*)params;
+ (NSDictionary*)getBranchParams;


+ (void)setDelayedCouponEligibility:(BOOL)isEligible;
+ (BOOL)getDelayedCouponEligibility;

+ (void)setCouponRedeemedStatus:(BOOL)isRedeemed;
+ (BOOL)getCouponRedeemedStatus;

+(BOOL)isInternetConnectionExists;


+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)messageWithCompletion:(void (^)(BOOL isSuccess))block;


@end

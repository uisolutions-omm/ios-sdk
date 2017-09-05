

#import <Foundation/Foundation.h>

@interface Config : NSObject

+ (id)getInstance;

@property(nonatomic, retain) NSString *BSNL_RECHARGE_URL;
@property(nonatomic, retain) NSString *MOBILE_NUMBER_KEY;
@property(nonatomic, retain) NSString *VPIN_KEY;
@property(nonatomic, retain) NSString *SECRET_CODE_KEY;
@property(nonatomic, retain) NSString *SECRET_CODE;


@property(nonatomic, retain) NSString *GOOGLE_APP_ID;
@property(nonatomic, retain) NSString *BUNDLE_ID;
@property(nonatomic, retain) NSString *GCM_SENDER_ID;
@property(nonatomic, retain) NSString *API_KEY;
@property(nonatomic, retain) NSString *CLIENT_ID;
@property(nonatomic, retain) NSString *TRACKING_ID;
@property(nonatomic, retain) NSString *ANDROID_CLIENT_ID;
@property(nonatomic, retain) NSString *DATABASE_URL;
@property(nonatomic, retain) NSString *STORAGE_BUCKET;
@property(nonatomic, retain) NSString *DEEP_LINK_URL_SCHEME;
@property(nonatomic, retain) NSString *MISSED_CALL_PHONENUMBER_KEY;


@property(nonatomic, retain) NSString *BRANCH_BASE_URL;
@property(nonatomic, retain) NSString *BRANCH_KEY;
@property(nonatomic, retain) NSString *BRANCH_SECRET;
@property(nonatomic, retain) NSString *BRANCH_CAMPAIGN;
@property(nonatomic, retain) NSString *RECHARGE_URL;
@property(nonatomic, retain) NSString *CONTACTS_UPLOAD_URL;
@property(nonatomic, retain) NSString *GENERATE_COUPON_URL;
@property(nonatomic, retain) NSString *SHOP_ID;
@property(nonatomic, retain) NSString *EIGHTY_G_URL;


@end


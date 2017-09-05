
//
//  OMMWifiAPIController.m
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


@interface OMMWifiAPIController()<CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *contactMutable;

- (void)rechargeViaDeepLink:(void (^) (NSString *response, NSDictionary *logs, NSError *error))completion;

@end

@implementation OMMWifiAPIController


/**
 Get Shared Instance

 @return OMMWifiAPIController Singleton Instance
 */
+ (id)sharedInstance {
    static OMMWifiAPIController *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}



/**
 Recharge Particular Mobile Number

 @param mobileNumber - User's Mobile Number
 @param isDirectRecharge - Make direct recharge based on location
 @param completion - Response of recharge status
 */
- (void)issueRechargeMobileNumber:(NSString*)mobileNumber AndisDirectRecharge:(BOOL)isDirectRecharge withCompletion:(void (^) (NSString *ommResponse, NSError *ommError))completion {
    
    [[FirebaseAPIController sharedInstance] signUpFirebase:mobileNumber withCompletion:^(NSString *uid, NSError *anError) {
        
            if (anError != nil) {
                completion(nil, anError);
                return;
            }
            
            NSURL *url = [NSURL URLWithString:[[Config getInstance] RECHARGE_URL]];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:[NSString stringWithFormat:@"%@%@",COUNTRY_CODE, mobileNumber]  forKey: [[Config getInstance] MOBILE_NUMBER_KEY]];
            [params setObject: [[Config getInstance] SECRET_CODE] forKey: [[Config getInstance] SECRET_CODE_KEY]];
            
            [[NetworkController sharedInstance] POSTRequestWithUrl:url withParameters:params withContentType:CONTENT_XFORM withCompletionBlock:^(NSData *response, NSError *error) {
                
                if (error != nil) {
                    NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:NETWORK_ERROR];
                    completion(nil, networkError);
                    return;
                }
                
                if (response != nil) {
                    
                    NSString *strResponse = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
                    
                    if (strResponse) {
                        if ([strResponse isEqualToString:ERROR_MSG_001]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_001];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse isEqualToString:ERROR_MSG_002]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_002];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse isEqualToString:ERROR_MSG_003]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_003];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse isEqualToString:ERROR_MSG_004]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_004];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse isEqualToString:ERROR_MSG_005]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_005];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse hasPrefix:ERROR_MSG_006]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_006];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse hasPrefix:ERROR_MSG_007]) {
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_007];
                            completion(nil, networkError);
                            return;
                            
                        }else if ([strResponse hasPrefix:ERROR_MSG_008]) {
                            completion(ERROR_MSG_008, nil);
                            return;
                        }else{
                            NSError *networkError = [[NetworkController sharedInstance] createError:OMMWIFI_ERROR andLocalDescription:ERROR_MSG_009];
                            completion(nil, networkError);
                            return;
                        }
                        
                    }
                }
            }];
    }];
    
}



    
/**
 Intialise Recharge based on deeplink parameters

 @param completion - Response of recharge status
 */
- (void)rechargeViaDeepLink:(void (^) (NSString *response, NSDictionary *logs, NSError *error))completion{
    
    Branch *branch = [Branch getInstance];
    
    [branch initSessionWithLaunchOptions:nil andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        
        NSString *mobileNumber;
        NSDictionary *dictRef = [[NSDictionary alloc] initWithDictionary:params];
        
        [Utility setBranchParams:params];
        
        if ([[params valueForKey:IS_CHECKINNOW_KEY] isEqualToString:@"true"] || [[params valueForKey:IS_CHECKINNOW_KEY] isEqualToString:@"false"]) {
            
            // Is from branch link app install
            if ([[params valueForKey:IS_CHECKINNOW_KEY] isEqualToString:@"true"]) {
                
                mobileNumber = [params valueForKey:BRANCH_MOBILE_NUMBER_KEY];
                
                [Utility setMobileNumber:mobileNumber];
                
                [[OMMWifiAPIController sharedInstance] issueRechargeMobileNumber:mobileNumber AndisDirectRecharge:NO withCompletion:^(NSString *resp, NSError *err) {
                    if ([resp isEqualToString:@"Success"]) {
                        [Utility setCouponRedeemedStatus:YES];
                        [Utility setDelayedCouponEligibility:NO];
                        [self showAlert:@"Congratulations !!\n you have been successfully recharged." AndMessage:@"" AndButtonTitle:@"Done"];
                    }else{
                        
                        if ([resp isEqualToString:@"Please register your mobile number with BSNL"]) {
                            [self showAlert:@"Please register your mobile number with BSNL" AndMessage:@"" AndButtonTitle:@"OK"];
                        }else if([resp isEqualToString:@"Already Redeemed"]){
                            [Utility setCouponRedeemedStatus:YES];
                            [Utility setDelayedCouponEligibility:NO];
                            [self showAlert:@"You have already redeemed your coupon !" AndMessage:@"" AndButtonTitle:@"OK"];
                        }else{
                            //[self showAlert:@"Something went wrong. Please check your email for coupon\n(check spam folder too)" AndMessage:@"" AndButtonTitle:@"OK"];
                            [self showAlert:@"Something went wrong! \nPlease re-open your app after sometime." AndMessage:@"" AndButtonTitle:@"OK"];
                        }
                    }
                    
                    
                    if (err != nil) {
                        
                        NSString *descp = err.localizedDescription;
                        
                        if ([descp isEqualToString:@"Currently coupons are unavailable !"]) {
                            [self showAlert:@"Sorry for the inconvenience caused ! Due to high demand,currently coupons are  unavailable right now. Please try after some time." AndMessage:@"" AndButtonTitle:@"OK"];
                        }
                    }
                    
                    completion(resp, dictRef, err);
                    return;
                }];
                
            }else{
                
                [Utility setDelayedCouponEligibility:YES];

            }
        }else{
            
//            // Is from regular app install
//            BOOL isEligible = [Utility getDelayedCouponEligibility];
//            
//            if (isEligible) {
//                [self performOfflineRecharge];
//                //completion(@"Initialised offline recharge based on location", nil, nil);
//            }else{
//                completion(@"Not a branch flow", nil, nil);
//            }
            
        }

    }];
}



/**
 Enable OnScreen Logs

 @param logg - Logged String
 */
- (void)showLogs:(NSString*)logg{
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    txtView.backgroundColor = [UIColor whiteColor];
    txtView.textColor = [UIColor blackColor];
    txtView.alpha = 0.7;
    txtView.text = logg;
    
    [[[self applicationWindow] rootViewController].view addSubview:txtView];
    
}



/**
 Shows the alert

 @param title - Title for alert
 @param message - Message for alert
 @param buttonTitle - Title for alert button
 */
- (void)showAlert:(NSString*)title AndMessage:(NSString*)message AndButtonTitle: (NSString*)buttonTitle{
 
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        if ([buttonTitle isEqualToString:@"Done"]) {
            [self showContactUploadAlert:@"Do you want to upload your contacts?" AndMessage:@"" AndButtonTitle:@""];
        }
        
        if ([buttonTitle isEqualToString:@"Call"]) {
            NSString *phoneNumber = [[Config getInstance] MISSED_CALL_PHONENUMBER_KEY];
            NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }];
    [alert addAction:okAction];
    [[[self applicationWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}




/**
 Shows alert for contact upload

 @param title - Title for alert
 @param message - Message for alert
 @param buttonTitle Title for alert button
 */
- (void)showContactUploadAlert:(NSString*)title AndMessage:(NSString*)message AndButtonTitle: (NSString*)buttonTitle{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        
        [self uploadContactsToServer];
        
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        
        
        
    }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [[[self applicationWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}




/**
 Upload Contacts to the server
 */
- (void)uploadContactsToServer{
    
    [self getContacts:^(NSArray *contactObjects) {
       
        if (contactObjects.count != 0){
            
            NSLog(@"----> Contacts %@", contactObjects);
         
            NSURL *url = [NSURL URLWithString:[[Config getInstance] CONTACTS_UPLOAD_URL]];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject: @"TollyTeaser" forKey: APP_NAME];
            [params setObject: [contactObjects description] forKey: ARRAY_KEY];
            [params setObject: [Utility getMobileNumber] forKey: MOBILE];
            [params setObject: [[Config getInstance] SECRET_CODE] forKey: [[Config getInstance] SECRET_CODE_KEY]];
            
            
            [[NetworkController sharedInstance] POSTRequestWithUrl:url withParameters:params withContentType:CONTENT_XFORM withCompletionBlock:^(NSData *response, NSError *error) {
                
                NSLog(@"----> Contacts Response %@", [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding]);
                
                if (error != nil) {
                    [self showAlert:@"Error while uploading contacts." AndMessage:@"" AndButtonTitle:@"OK"];
                }
                
                if (response != nil) {

                    NSString *strResponse = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
                    
                    if ([strResponse isEqualToString:@"Success"]) {
                        [self showAlert:@"Contacts successfully uploaded." AndMessage:@"" AndButtonTitle:@"OK"];
                    }else{
                        [self showAlert:@"Error while uploading contacts." AndMessage:@"" AndButtonTitle:@"OK"];
                    }
                }
            }];
            
        }
        
    }];
    
}




/**
 Retreive Contacts from server

 @param completion - Array of contact objects
 */
- (void)getContacts:(void (^)(NSArray *contactObjects))completion{
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
                completion(nil);
                return;
            } else {
                
                if (cnContacts.count != 0) {
                    
                    _contactMutable = [[NSMutableArray alloc] init];
                    
                    for (CNContact *contact in cnContacts) {
                        
                        NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
                        CNLabeledValue<CNPhoneNumber *> *firstPhone = [phoneNumbers firstObject];
                        CNPhoneNumber *number = firstPhone.value;
                        NSString *digits = number.stringValue; // 1234567890
                        //NSString *label = firstPhone.label;
                        
                        //NSLog(@"name ----> %@",digits);
                        if ([self validatePhone:digits] == YES) {
                            [_contactMutable addObject: [self extractNumberFromText:digits]];
                        }
                    }
                    
                    completion(_contactMutable);
                    return;
                    
                }else{
                    completion(nil);
                    return;
                }
            }
        }
    }];
    
}



/**
 Validate Phone Number

 @param phoneNumber - User's Mobile Number
 @return - Boolean denoting valid phone number or not
 */
- (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}



    
/**
 Extract Number from a string

 @param text - Input String
 @return - String containing only numbers
 */
- (NSString *)extractNumberFromText:(NSString *)text
    {
        NSString *newString = [[text componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return newString;
    }




/**
 Shows popup

 @return - UIView
 */
- (UIView*)sharedPopUpView{
    static dispatch_once_t onceToken;
    static UIView *bgView = nil;
    dispatch_once(&onceToken, ^{
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getScreenRect].size.width, [self getScreenRect].size.height)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        bgView.alpha = 0.0;
        
        CGRect popUpframe = CGRectMake(0, 0, bgView.frame.size.width * 0.9, bgView.frame.size.height * 0.4);
        
        UIView *popUpView = [[UIView alloc] init];
        popUpView.frame = popUpframe;
        popUpView.center = bgView.center;
        popUpView.backgroundColor = [UIColor whiteColor];
        popUpView.layer.cornerRadius = 6.0;
        popUpView.layer.masksToBounds = YES;
        
        UILabel *hiLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, popUpView.frame.size.width, 30)];
        hiLbl.text = @"Your Mobile Number";
        hiLbl.textAlignment = NSTextAlignmentCenter;
        hiLbl.textColor = [UIColor lightGrayColor];
        hiLbl.font = [UIFont systemFontOfSize:18];
        
        UILabel *mobNumbLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 45 + hiLbl.frame.size.height, popUpView.frame.size.width, 40)];
        mobNumbLbl.text = [Utility getMobileNumber];
        mobNumbLbl.textAlignment = NSTextAlignmentCenter;
        mobNumbLbl.textColor = [UIColor darkGrayColor];
        mobNumbLbl.font = [UIFont systemFontOfSize:30.0];
        
        UIButton *wifiBtn = [[UIButton alloc] initWithFrame:CGRectMake(popUpView.frame.size.width/2 - (popUpView.frame.size.width * 0.8)/2, mobNumbLbl.frame.origin.y + mobNumbLbl.frame.size.height + 20, popUpView.frame.size.width * 0.8, 36)];
        wifiBtn.backgroundColor = [UIColor colorWithRed:0 green:182.0/255.0 blue:255.0/255.0 alpha:1.0];
        [wifiBtn setTitle:@"Register & Connect Wifi" forState:UIControlStateNormal];
        [wifiBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [wifiBtn addTarget:self action:@selector(wifiButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        wifiBtn.layer.cornerRadius = 5;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(popUpView.frame.size.width/2 - (popUpView.frame.size.width * 0.8)/2, wifiBtn.frame.origin.y + wifiBtn.frame.size.height + 10, popUpView.frame.size.width * 0.8, 36)];
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0 green:182.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        
        [cancelBtn addTarget:self action:@selector(cancelButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.cornerRadius = 5;
        
        [popUpView addSubview:mobNumbLbl];
        [popUpView addSubview:hiLbl];
        [popUpView addSubview:wifiBtn];
        [popUpView addSubview:cancelBtn];
        [bgView addSubview:popUpView];
    });
    return bgView;
}


/**
 Get Screen Rect

 @return - CGRect
 */
- (CGRect)getScreenRect{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect;
}


/**
 Get Appilcation Window

 @return - UIWindow
 */
- (UIWindow *)applicationWindow {
    return [UIApplication sharedApplication].keyWindow;
}



/**
 Initialise CoreLocation instance
 */
- (void)initialiseCoreLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLHeadingFilterNone];
    //change the desired accuracy to kCLLocationAccuracyBest
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
    [locationManager setPausesLocationUpdatesAutomatically:NO];
    [locationManager startUpdatingLocation];
}


/**
 CLLocationManager Delegate Methods

 @param manager - CLLocationManager Instance
 @param locations - Array of updated locations
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    
    CLLocation *location = locations[locations.count-1];
    
    //double latValue = location.coordinate.latitude;
    //double longValue = location.coordinate.longitude;
    
    if (location) {
        
        //If Internet
        NSArray *arrLocation = [self readLocationJSON];
        
        for (CLLocation *loc in arrLocation) {
            if ([location distanceFromLocation:loc] <= 200) {
                
                NSString *mobileNum = [Utility getMobileNumber];
                
                if (mobileNum.length != 10) {
                    return;
                }
                
                [[OMMWifiAPIController sharedInstance] issueRechargeMobileNumber:mobileNum AndisDirectRecharge:YES withCompletion:^(NSString *resp, NSError *err) {
                    
                    if ([resp isEqualToString:@"Success"]) {
                        [Utility setCouponRedeemedStatus:YES];
                        [Utility setDelayedCouponEligibility:NO];
                        [self showAlert:@"Congratulations !!\n you have been successfully recharged." AndMessage:@"" AndButtonTitle:@"Done"];
                    }else{
                        
                        if ([resp isEqualToString:@"Please register your mobile number with BSNL"]) {
                            [self showAlert:@"Please register your mobile number with BSNL" AndMessage:@"" AndButtonTitle:@"OK"];
                        }else if([resp isEqualToString:@"Already Redeemed"]){
                            [Utility setCouponRedeemedStatus:YES];
                            [Utility setDelayedCouponEligibility:NO];
                            [self showAlert:@"You have already redeemed your coupon !" AndMessage:@"" AndButtonTitle:@"OK"];
                        }else{
                            //[self showAlert:@"Something went wrong. Please check your email for coupon\n(check spam folder too)" AndMessage:@"" AndButtonTitle:@"OK"];
                            [self showAlert:@"Something went wrong! \nPlease re-open your app after sometime." AndMessage:@"" AndButtonTitle:@"OK"];
                        }
                    }
                }];
                
                [manager stopUpdatingLocation];
                manager = nil;
                
                break;
            }
        }
        
        
        //If No Internet
        //SMS
    }
    
    
}



/**
 CLLocationManager Delegate Methods

 @param manager - CLLocationManager Instance
 @param error - Error while getting location
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location Error %@", error);
}



/**
 Performs Offline Recharge
 */
- (void)performOfflineRecharge{
    //Initialise locationManager
    [self initialiseCoreLocation];
    
}


/**
 Read JSON from local json file

 @return - Array of location objects
 */
- (NSArray*)readLocationJSON{
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"qfi_locations" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError * error;
    if(error)
    {
        NSLog(@"Error reading file: %@",error.localizedDescription);
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"JSON -> %@", dict);
    
    NSArray *arrLocation = (NSArray*)[dict valueForKey:@"marker"];
    NSMutableArray *arrCLLocations;
    
    if (arrLocation.count != 0) {
        arrCLLocations = [[NSMutableArray alloc] init];
    }else{
        return nil;
    }
    
    for (NSDictionary *obj in arrLocation) {
        
        double latitude = [[obj valueForKey:@"lat"] doubleValue];
        double longitude = [[obj valueForKey:@"lng"] doubleValue];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [arrCLLocations addObject:loc];
    }
    
    return arrCLLocations;
}



/**
 Checks Firebase Integration
 */
- (void)testIntegration{
    [[FirebaseAPIController sharedInstance] testIntegration];
}


/**
 Send SMS
 */
- (void)sendSMS{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSString *serviceNumber = @"";
        controller.body = @"SMS message here";
        controller.recipients = [NSArray arrayWithObjects:serviceNumber, nil];
        controller.messageComposeDelegate = self;
        [[[self applicationWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
    }
}



/**
 MFMessageComposeViewController Delegate Method

 @param controller - MFMessageComposeViewController
 @param result - MessageComposeResult
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
}


/**
 Executes CheckIn
 */
- (void)executeCheckIn{
    
    NSDictionary *bParams = [Utility getBranchParams];
    
    if ([[bParams valueForKey:IS_CHECKINNOW_KEY] isEqualToString:@"true"]) {
        
        [self showAlert:@"You have already redeemed your coupon !" AndMessage:@"" AndButtonTitle:@"OK"];
        
    }else{
    
        // Is from regular app install or checkin later
        BOOL isAlreadyRedeemed = [Utility getCouponRedeemedStatus];
        
        if (isAlreadyRedeemed == NO) {
            
            BOOL isEligible = [Utility getDelayedCouponEligibility];
            
            if (isEligible == YES) {
                
                if ([Utility isInternetConnectionExists]) {
                    [self performOfflineRecharge];
                }else{
                    [self showAlert:@"Looks like you don't have internet connection\nplease give a missed call to this number 08030636142 to get your coupon !" AndMessage:@"" AndButtonTitle:@"Call"];
                }
            }else{
                [self showAlert:@"You are not eligible to this offer !" AndMessage:@"" AndButtonTitle:@"OK"];
            }
        }else{
            [self showAlert:@"You have already redeemed your coupon !" AndMessage:@"" AndButtonTitle:@"OK"];
        }
    }
}




/**
 Checks Clever Tap Integration
 */
- (void)checkCleverTap{
    
    [CleverTap changeCredentialsWithAccountID:@"TEST-Z84-84Z-R94Z" andToken:@"TEST-14b-4b1"];
    [CleverTap autoIntegrate];
    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:nil andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        
        if (error == nil) {
            NSString *username = [params valueForKey:@"Username"];
            NSString *channel = [params valueForKey:@"Channel"];
            
            if (username!=nil && channel!=nil) {
                NSDateComponents *dob = [[NSDateComponents alloc] init];
                dob.day = 24;
                dob.month = 5;
                dob.year = 1992;
                NSDate *d = [[NSCalendar currentCalendar] dateFromComponents:dob];
                NSDictionary *profile = @{
                                          @"Name": username,               // String
                                          @"Identity": [self getRandomPINString:8],                 // String or number
                                          @"Email": [NSString stringWithFormat:@"%@@gmail.com",username],            // Email address of the user
                                          @"Phone": @"+00000000000",              // Phone (with the country code, starting with +)
                                          @"Gender": @"M",                        // Can be either M or F
                                          @"Employed": @"Y",                      // Can be either Y or N
                                          @"Education": @"Graduate",              // Can be either Graduate, College or School
                                          @"Married": @"Y",                       // Can be either Y or N
                                          @"DOB": d,                              // Date of Birth. An NSDate object
                                          @"Age": @28,                            // Not required if DOB is set
                                          @"Tz": @"Asia/Kolkata",                 //an abbreviation such as "PST", a full name such as "America/Los_Angeles",
                                          //or a custom ID such as "GMT-8:00"
                                          @"Photo": @"", // URL to the Image
                                          
                                          // optional fields. controls whether the user will be sent email, push etc.
                                          @"MSG-email": @NO,                      // Disable email notifications
                                          @"MSG-push": @YES,                      // Enable push notifications
                                          @"MSG-sms": @NO                         // Disable SMS notifications
                                          };
                
                [[CleverTap sharedInstance] profileAddMultiValue:channel forKey:@"Channel"];
                [[CleverTap sharedInstance] profilePush:profile];
            }
        }
        
    }];
    
}


/**
 Create Random String of desired length

 @param length - Length of the string
 @return - Randomly generated string
 */
-(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];

    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}




/**
 Perform OMMWifi Recharge
 */
- (void)performWifiRecharge{
    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:nil andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        
        [Utility setBranchParams:params];
        
        
        if (![[params allKeys] containsObject:@"isWifiScheme"]) {
            NSLog(@"NOT A WIFI SCHEME");
            return;
        }
        
        if ([[params allKeys] containsObject:@"domain"]) {
            if ([[[params valueForKey:@"domain"] description] isEqualToString:@"80g-donation"]) {
                
                
                //////////////////////////////////////////////////////////
                //-------------------- 80G Donation --------------------//
                //////////////////////////////////////////////////////////
                
                //Params
                NSString *phoneNumber = [[params valueForKey:@"mobileNumber"] description];
                NSString *name = [[params valueForKey:@"name"] description];
                NSString *email = [[params valueForKey:@"email-id"] description];
                
                [[OMMWifiAPIController sharedInstance] perform80GActionWithPhoneNumber:phoneNumber andName:name andEmail:email];
                
                
                
            }else if([[[params valueForKey:@"domain"] description] isEqualToString:@"airport-wifi.in"]){
                
                ///////////////////////////////////////////////////////////////////
                //-------------------- Airport Wifi Recharge --------------------//
                ///////////////////////////////////////////////////////////////////
                
                [self rechargeViaDeepLink:^(NSString *response, NSDictionary *logs, NSError *error) {
                    
                    if (error != nil) {
                        [Utility showAlertWithTitle:[error localizedDescription] andMessage:@"" :nil];
                        return;
                    }

                    if (response != nil) {
                        if (response != nil) {
                            if ([response hasPrefix:@"Success"]) {
                                [Utility showAlertWithTitle:@"Congratulations !!\n you have been successfully recharged." andMessage:@"" :nil];
                                return;
                            }
                            if ([response isEqualToString:@"Already Redeemed !"]) {
                                [Utility showAlertWithTitle:@"Already Redeemed !" andMessage:@"" :nil];
                            }
                        }}
                }];
            }
            
        }else{
            ///////////////////////////////////////////////////////////
            //-------------------- Wifi Recharge --------------------//
            ///////////////////////////////////////////////////////////
            
            [self rechargeViaDeepLink:^(NSString *response, NSDictionary *logs, NSError *error) {
                
                if (error != nil) {
                    [Utility showAlertWithTitle:[error localizedDescription] andMessage:@"" :nil];
                    return;
                }
                
                if (response != nil) {
                    if (response != nil) {
                        if ([response hasPrefix:@"Success"]) {
                            [Utility showAlertWithTitle:@"Congratulations !!\n you have been successfully recharged." andMessage:@"" :nil];
                            return;
                        }
                        if ([response isEqualToString:@"Already Redeemed !"]) {
                            [Utility showAlertWithTitle:@"Already Redeemed !" andMessage:@"" :nil];
                        }
                    }}
            }];
            
        }
        
    }];
    
}




/**
 Perform 80G Donation API

 @param phoneNumber - User's Phonenumber
 @param name - Name of the user
 @param email - Email of the user
 */
- (void)perform80GActionWithPhoneNumber:(NSString*)phoneNumber andName:(NSString*)name andEmail:(NSString*)email{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?phonenumber=%@&secretCode=%@&name=%@&email=%@",[[Config getInstance] EIGHTY_G_URL], phoneNumber, [[Config getInstance] SECRET_CODE], name, email];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NetworkController sharedInstance] POSTRequestWithUrl:url withParameters:nil withContentType:nil withCompletionBlock:^(NSData *response, NSError *error) {
        
        if (error != nil) {
            [Utility showAlertWithTitle:[error localizedDescription] andMessage:@"" :nil];
            return;
        }
        
        if (response != nil) {
            
            NSString *strResponse = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
            
            if (strResponse != nil) {
                
                if ([strResponse hasPrefix:@"Success"]) {
                    [Utility showAlertWithTitle:@"Congratulations !!\n you have been successfully recharged." andMessage:@"" :nil];
                    return;
                }
                
                if ([strResponse isEqualToString:@"Already Redeemed !"]) {
                    [Utility showAlertWithTitle:@"Already Redeemed !" andMessage:@"" :nil];
                }
            }}
    }];

}


@end

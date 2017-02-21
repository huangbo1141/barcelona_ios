//
//  CGlobal.h
//  SchoolApp
//
//  Created by apple on 9/24/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "WNAActivityIndicator.h"
#import "NSString+Common.h"
#import "CustomTextField.h"
#import "EnvVar.h"
#import <CoreLocation/CLLocation.h>

extern  UIColor*   COLOR_TOOLBAR_TEXT;
extern  UIColor*   COLOR_TOOLBAR_BACK;
extern  UIColor*   COLOR_PRIMARY;
extern  UIColor*   COLOR_SECONDARY_PRIMARY;
extern  UIColor*   COLOR_SECONDARY_GRAY;
extern  UIColor*   COLOR_SECONDARY_THIRD;
extern  UIColor*   COLOR_RESERVED;


extern int gms_camera_zoom;
extern NSDictionary*g_launchoptions;
//basic data



//notifications
extern NSString *GLOBALNOTIFICATION_DATA_CHANGED_PHOTO ;
extern NSString *GLOBALNOTIFICATION_MAP_PICKLOCATION ;
extern NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC;
extern NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL;
extern NSString *GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER;
extern NSString *GLOBALNOTIFICATION_CHANGEVIEWCONTROLLERREBATE;
extern NSString *GLOBALNOTIFICATION_MQTTPAYLOAD;
extern NSString *GLOBALNOTIFICATION_MQTTPAYLOAD_PROCESS;
extern NSString *GLOBALNOTIFICATION_TRENDINGRESET;
extern NSString *GLOBALNOTIFICATION_LIKEDBUTTON;

extern NSString *NOTIFICATION_RECEIVEUUID;
extern NSString *NOTIFICATION_PAGECHANGE;

extern NSString *const kPhotoManagerChangedContentNotificationHot;
extern NSString *const kPhotoManagerChangedContentNotificationFresh;
extern NSString *const kPhotoManagerChangedContentNotificationOthers;

//menu height
extern CGFloat GLOBAL_MENUHEIGHT;
extern CGFloat GLOBAL_MENUWIDTH;

typedef void (^PermissionCallback)(BOOL ret);

@interface CGlobal : NSObject
+ (CGlobal *)sharedId;
@property (nonatomic, assign) CLLocationCoordinate2D defaultPos;
@property (nonatomic, strong) EnvVar * env;

// COMMON FUMCTIONS
+(void)makeTermsPrivacyForLabel: (TTTAttributedLabel *) label withUrl:(NSString*)urlString;
+(void)initSample;
+(int)getOrientationMode;
+(void)showIndicator:(UIViewController*)viewcon;
+(void)stopIndicator:(UIViewController*)viewcon;
+(void)showIndicatorForView:(UIView*)viewcon;
+(void)stopIndicatorForView:(UIView*)viewcon;
+(void)AlertMessage:(NSString*)message Title:(NSString*)title;
+(void)backProcess;
+(void)backProcess:(UIViewController*)con Delegate:(id)mydelegate;
+(void)makeBorderBlackAndBackWhite:(UIView*)target;
+(void)makeBorderASUITextField:(UIView*)target;
+(CGFloat)heightForView:(NSString*)text Font:(UIFont*) font Width:(CGFloat) width;
+(NSString*)getUDID;
+(void)setDefaultBackground:(UIViewController*)viewcon;
+(NSString*) jsonStringFromDict:(BOOL) prettyPrint Dict:(NSDictionary*)dict;
+(NSString*)getEncodedString:(NSString*)input;
//+(BOOL)gotoViewController:(UIViewController*)controller Mode:(int) mode;

+(NSString*)getDateFromPickerForDb:(UIDatePicker*)datePicker;
+(NSDate*)getDateFromDbString:(NSString*)string;
+(NSDate*)getLocalDateFromDbString:(NSString*)string;
+(NSString*)getLocalDateFromDBString:(NSString*)string;
+(NSString*)getGmtHour;
+(NSString*)getCurrentTimeInGmt0;
+(NSString*)getTimeStringFromDate:(NSDate*)sourceDate;
+(NSArray*)getIntegerArrayFromRids:(NSString*)rids;
+(NSString*)getFormattedTimeFormPicker:(UIDatePicker*)picker;
+(int)ageFromBirthday:(NSDate *)birthdate;
+(NSString*)getAgoTime:(NSString*)param1 IsGmt:(BOOL)isGmt;
+(NSNumber*)getNumberFromStringForCurrency:(NSString*)formatted_str;
+(NSString*)getStringFromNumberForCurrency:(NSNumber*)number;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert Alpha:(CGFloat)alpha;
+(void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url withView:(UIView*)view withController:(UIViewController*)controller;
+ (NSString *)urlencode:(NSString*)param1;

+(NSString*)timeStamp;
+(NSTimeInterval)timeStampInterval;
// program specific
+(void)setStyleForInput1:(UIView*)buttonView;
+(void)setStyleForInput2:(UIView*)viewRound View:(UIView*)viewtext Radius:(CGFloat)radius;
+(void)setStyleForInput3:(UIView*)viewRound TextField:(UITextField*)textField LeftorRight:(BOOL)isLeft Radius:(CGFloat)radius SelfView:(UIView*)view;
+(void)showMenu:(UIViewController*)viewcon;
+(void)hideMenu;
+(void)toggleMenu:(UIViewController*)viewcon;
+(void)addRangeSlider:(UIView*)view Min:(CGFloat)min Max:(CGFloat)max RangeSlider:(id)m_slider WithFrame:(CGRect)rect SliderType:(int)type;
+(NSString*)checkTimeForCreateBid:(NSString*)string;
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
+ (UIImage*)getScaledImage:(UIImage*)image Source:(UIImagePickerControllerSourceType)sourceType;
+(void)removeDuplicatesForPhotos:(NSMutableArray*)source WithData:(NSMutableArray*)data;
//PARSING JSON

+(UIImage*)getImageForMap:(UIImage*)bm NSString:(NSString*)number;
+(UIImage*)getImageForMap:(NSString*)number;
-(instancetype)initWithDictionary:(NSDictionary*) dict;
+(NSMutableDictionary*)getQuestionDict:(id)targetClass;
+(void)parseResponse:(id)targetClass Dict:(NSDictionary*)dict;
+(id)getDuplicate:(id)targetClass;

+(NSData*)buildJsonData:(id)targetClass;
+ (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (CGSize)getSizeForAspect:(UIImage*)image Frame:(CGSize)frame;
+ (CGSize)getSizeForAspectFromSize:(CGSize)imageSize Frame:(CGSize)frame;
+(void)grantedPermissionCamera:(PermissionCallback)callback;
+(void)grantedPermissionMediaLibrary:(PermissionCallback)callback;
+(void)grantedPermissionPhotoLibrary:(PermissionCallback)callback;
@end

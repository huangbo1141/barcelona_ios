
#import <Foundation/Foundation.h>

@interface EnvVar : NSObject
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * tutype;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * fbtoken;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * fbid;
@property (nonatomic, assign) long lastLogin;
@property (nonatomic, copy) NSString * pushtoken;

@property (nonatomic, copy) NSString * first_name;
@property (nonatomic, copy) NSString * last_name;
@property (nonatomic, copy) NSString * country;
@property (nonatomic, assign) long introviewed;

- (BOOL)hasLoginDetails;
- (void)logOut;
- (void) loadFromDefaults;

- (id) initTemp;

- (void)saveDefaults:(NSString *)key value:(id)obj;

////customFunctions
//-(void)saveToken;
//
//- (void)setUsername:(NSString *)username;
//- (void)setPassword:(NSString *)password;
//
//
//#pragma mark - Other Preference Values
//- (void)setLastLogin:(long)lastLogin;
//-(void)setIntroviewed:(long)introviewed;
@end

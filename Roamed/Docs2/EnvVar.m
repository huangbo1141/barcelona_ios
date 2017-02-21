
#import "EnvVar.h"
#import "macros.h"
#import "CGlobal.h"
//Login keys
static NSString * kDefaultsUserNameKey = @"username";
static NSString * kDefaultsPasswordKey = @"password";

//updated keys
static NSString * kDefaultsLastLoggedInKey = @"LASTLOGGEDIN";

//My own keys


@interface EnvVar()
{
    BOOL bSaveDefaults;
}
@end

@implementation EnvVar

- (long) udLong:(NSString *)key default:(long)v
{
    if (UDValue(key))
    {
        return UDInteger(key);
    }
    else
    {
        //set default value and return default value;
        UDSetInteger(key, v);
        UDSync();
        return v;
    }
}
- (void) loadFromDefaults
{
    
    _username = UDValue(kDefaultsUserNameKey);
    _password = UDValue(kDefaultsPasswordKey);
    _tutype = UDValue(@"tutype");
    
    
    _lastLogin = UDInteger(kDefaultsLastLoggedInKey);
    _token = UDValue(@"token");
    _fbid = UDValue(@"fbid");
    _first_name = UDValue(@"first_name");
    _last_name = UDValue(@"last_name");
    _country = UDValue(@"country");
    _introviewed = UDInteger(@"introviewed");
    
    if(_tutype == nil){
        _tutype = @"3";  //  normal user
    }
    if (_token == nil) {
        _token = @"123456789";
    }
    
    if (_pushtoken == nil) {
        _pushtoken = @"";
    }
    
    if (_first_name == nil) {
        _first_name = @"";
    }
    if (_last_name == nil) {
        _last_name = @"";
    }
    if (_country == nil) {
        _country = @"";
    }
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        bSaveDefaults = YES;
        [self loadFromDefaults];
    }
    return self;
}

- (id) initTemp
{
    self = [super init];
    if (self != nil)
    {
        bSaveDefaults = NO;
    }
    return self;
}

#pragma mark - Login environment variables....
- (void)saveDefaults:(NSString *)key value:(id)obj
{
    if (bSaveDefaults)
    {
        if (obj != nil)
            UDSetValue(key, obj);
        else
            UDRemove(key);
        UDSync();
    }

}

- (void)saveDefaultsLong:(NSString *)key value:(long)v
{
    if (bSaveDefaults)
    {
        UDSetInteger(key, v);
        UDSync();
    }
}
- (void)setUsername:(NSString *)username
{
    _username = [username copy];
    [self saveDefaults:kDefaultsUserNameKey value:username];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    [self saveDefaults:kDefaultsPasswordKey value:password];
}
- (void)setTutype:(NSString *)tutype{
    _tutype = tutype;
    [self saveDefaults:@"tutype" value:tutype];
}

- (BOOL)hasLoginDetails
{
    return self.username != nil && self.password != nil;
}

- (void)logOut
{
    [self setLastLogin:-1];
    
}


#pragma mark - Other Preference Values
- (void)setLastLogin:(long)lastLogin
{
    _lastLogin = lastLogin;
    [self saveDefaultsLong:kDefaultsLastLoggedInKey value:lastLogin];
}
-(void)setIntroviewed:(long)introviewed
{
    _introviewed = introviewed;
    [self saveDefaultsLong:@"introviewed" value:introviewed];
}

//custom token
-(void) saveToken{
}

@end

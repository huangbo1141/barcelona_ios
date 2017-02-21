//
//  NetworkParser.h
//  SchoolApp
//
//  Created by TwinkleStar on 11/27/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGlobal.h"

typedef void (^NetworkCompletionBlock)(NSDictionary*dict, NSError* error);


@interface NetworkParser : NSObject
+ (instancetype)sharedManager;

- (void)uploadImage:(NSData*)data FileName:(NSString*)fileName ApiPath:(NSString*)apiPath withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)uploadImageToServer:(NSData*)data FileName:(NSString*)fileName ApiPath:(NSString*)apiPath Mode:(int)whichserver withCompletionBlock:(NetworkCompletionBlock)completionBlock ;
- (void)uploadVideo:(NSString*)fileName ApiPath:(NSString*)apiPath FileURL:(NSURL*)fileURL withCompletionBlock:(NetworkCompletionBlock)completionBlock;
-(void)ontemplateGeneralRequest:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock;
-(void)ontemplateRequestWithNoCheck:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock;

-(void)ontemplateGeneralRequestWithRawUrl:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock;
-(void)ontemplateGeneralRequestWithRawUrlNoCheck:(id) data Path:(NSString*)url withCompletionBlock:(NetworkCompletionBlock)completionBlock;

@end

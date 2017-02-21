//
//  MyDialog.h
//  travpholer
//
//  Created by BoHuang on 7/11/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNACountry.h"

@protocol MyCountrySelectEvent
// list of methods and properties
-(void) didSelectCountry:(WNACountry*)country;
-(void) dieCancelCountry;
@end

@interface MyDialog : UIView<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView* contentView;
@property (nonatomic,strong) id<MyCountrySelectEvent> aDelegate;
@property (nonatomic,strong) NSArray* countryData;
@property (nonatomic,strong) UITableView* tableView;
-(void)setCustomView:(UIView*)view UnderView:(UIView*)refView Controller:(UIViewController<UITableViewDelegate,UITableViewDataSource>*)vc Padding:(CGPoint)padding;

@property (nonatomic,assign) int position;
-(void)setCountryDataWithData:(NSArray *)countryData currentData:(WNACountry*)data;

@end

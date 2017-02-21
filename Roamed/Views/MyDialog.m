//
//  MyDialog.m
//  travpholer
//
//  Created by BoHuang on 7/11/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "MyDialog.h"

#import "ComboDropTableViewCell.h"
@implementation MyDialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setCountryDataWithData:(NSArray *)countryData currentData:(WNACountry*)data{
    self.countryData = countryData;
    
    
    if (data == nil) {
        _position = 0;
    }else{
        for (int i=0; i<countryData.count; i++) {
            WNACountry* c = countryData[i];
            if ([c.countryName isEqualToString:data.countryName]) {
                _position = i;
                break;
            }
        }
    }
    
    [self.tableView reloadData];
}
-(void)setCustomView:(UIView*)view UnderView:(UIView*)refView Controller:(UIViewController*)vc Padding:(CGPoint)padding{

    CGFloat top = padding.y;
    CGRect baseRect;
    if (view != nil) {
        baseRect = view.frame;
    }
    _contentView = view;
    CGRect refFrame_global = [refView convertRect:refView.bounds toView:vc.view];
    
    
    if (view==nil) {
        baseRect.origin.x = refFrame_global.origin.x;
        baseRect.origin.y = refFrame_global.origin.y + refFrame_global.size.height + top + 1;
        baseRect.size = CGSizeMake(refFrame_global.size.width, 32.0f * 5);
        
        _tableView = [[UITableView alloc] initWithFrame:baseRect];
        
        UINib*nib = [UINib nibWithNibName:@"ComboDropTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"ComboDropTableViewCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [self addSubview:_tableView];
    }   
    
}
-(void)setADelegate:(id)aDelegate{
    if (_aDelegate!=aDelegate) {
        _aDelegate = aDelegate;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
        [self addGestureRecognizer:singleTap];
        [singleTap setDelegate:self];
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    // Disallow recognition of tap gestures in the segmented control.
    if (([touch.view isDescendantOfView:_tableView])) {//change it to your condition
        return NO;
    }
    return YES;
}
-(void)ClickGesture:(UITapGestureRecognizer*)gesture{
    UIView* view = gesture.view;
    int tag = view.tag;

    if (_aDelegate!=nil) {
        [_aDelegate dieCancelCountry];
    }
}

#pragma -mark TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    _position = (int)row;
    WNACountry* country = nil;
    if (row != 0) {
        country = _countryData[row];
    }
    [self removeFromSuperview];
    if (_aDelegate!=nil) {
        [_aDelegate didSelectCountry:country];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    
    
    ComboDropTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ComboDropTableViewCell" forIndexPath:indexPath];
    WNACountry* country = [_countryData objectAtIndex:[indexPath row] ];
    
    [cell setData:country.countryName Selected:_position == indexPath.row];
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _countryData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32.0f;
}
@end

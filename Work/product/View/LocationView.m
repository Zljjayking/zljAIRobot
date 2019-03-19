//
//  LocationVC.m
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/11/12.
//  Copyright © 2015年 kpkj-ios. All rights reserved.
//


#import "LocationView.h"
#import "LocationData.h"

#import "CommonCell.h"

@interface LocationView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_provinceArray;
    NSArray *_cityArray;
    NSArray *_areaArray;
    
    NSString * _backProd;
    NSString * _backCity;
    NSString * _backArea;
    
    NSInteger _areaId;
    NSInteger _cityId;
    NSInteger _prodId;
    NSInteger _currentIndex;
    
    
    UIView * _backView;
    UIButton * _cancelButton;
    UIButton * _ensureButton;
    UIView * _verticalLine;
    UITableView * _tableView;
    
    Province * _currentProvince;
    City * _currentCity;
}
@end

@implementation LocationView
-(id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.5];
        
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [_tableView registerClass:[CommonCell class] forCellReuseIdentifier:@"oneCell"];
        
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = TABBAR_BASE_COLOR;
        [_backView addSubview:_cancelButton];
        
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ensureButton.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
        [_ensureButton addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
        _ensureButton.backgroundColor = TABBAR_BASE_COLOR;
        [_backView addSubview:_ensureButton];
        
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_verticalLine];
        
        CGFloat rowHeight2 = [UIAdaption getAdaptiveHeightWith5SHeight:34];
        CGFloat maxHeight = kScreenHeight-148;
        CGFloat heit = maxHeight;
        
        _backView.center = CGPointMake([UIAdaption getAdaptiveWidthWith5SWidth:160], kScreenHeight/2.0);
        _backView.bounds = CGRectMake(0, 0, [UIAdaption getAdaptiveWidthWith5SWidth:200], heit);
        
        _tableView.frame = CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y, _backView.frame.size.width, _backView.frame.size.height-rowHeight2);
        
        _cancelButton.frame = CGRectMake(0, heit-rowHeight2, [UIAdaption getAdaptiveWidthWith5SWidth:100], rowHeight2);
        _ensureButton.frame = CGRectMake([UIAdaption getAdaptiveWidthWith5SWidth:100], heit-rowHeight2, [UIAdaption getAdaptiveWidthWith5SWidth:100], rowHeight2);
        _verticalLine.frame = CGRectMake([UIAdaption getAdaptiveWidthWith5SWidth:99.75], heit-rowHeight2, [UIAdaption getAdaptiveWidthWith5SWidth:0.5], rowHeight2);
        
        
        
        _provinceArray = [LocationData getProvinceArray];
        
    }
    return self;
}


-(void)reloadData
{
    self.hidden = NO;
    _currentIndex = 0;
    _areaId = 0;
    _cityId = 0;
    _prodId = 0;
    _backArea = nil;
    _backCity = nil;
    _backProd = nil;
    [_tableView reloadData];
}

#pragma mark --tableView dataSource function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex ==0)
    {
        return _provinceArray.count;
        
    }
    else if (_currentIndex == 1)
    {
        return _cityArray.count;
    }
    else
    {
        return _areaArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
    cell.blackView.hidden = YES;
    cell.whiteView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (_currentIndex == 0)
    {
        Province * province = _provinceArray[indexPath.row];
        cell.textLabel.text = province.provinceName;
    }
    else if(_currentIndex == 1)
    {
        City * city = _cityArray[indexPath.row];
        cell.textLabel.text = city.cityName;
    }
    else if (_currentIndex == 2)
    {
        Area * area = _areaArray[indexPath.row];
        cell.textLabel.text = area.areaName;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIAdaption getAdaptiveHeightWith5SHeight:44];
}
#pragma mark -- tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex == 2)
    {
        Area * area = _areaArray[indexPath.row];
        _areaId = area.areaId;
        _backArea = area.areaName;
    }
    else if (_currentIndex == 1)
    {
        City * city = _cityArray[indexPath.row];
        _cityId = city.cityId;
        _backCity = city.cityName;
        _currentCity = city;
        if (_firstPage != 1)
        {
            _areaArray = nil;
            if (city.areaArray && city.areaArray.count>0)
            {
                _currentIndex = 2;
                _areaArray = [LocationData getAreaArrayWithCity:city];
                [_tableView reloadData];
            }
        }
    }
    else if (_currentIndex == 0)
    {
        _currentIndex = 1;
        Province *province = _provinceArray[indexPath.row];
        _currentProvince = province;
        _prodId = province.provinceId;
        _backProd = province.provinceName;
        _cityArray = nil;
        if (province.cityArray && province.cityArray.count>0)
        {
            _cityArray = [LocationData getCityArrayWithProvince:province];
            [_tableView reloadData];
        }
    }
}
-(void)cancel
{
    if (_currentIndex == 2)
    {
        _currentIndex = 1;
        _areaId = 0;
        _cityId = 0;
        _backArea = nil;
        _backCity = nil;
        [_tableView reloadData];
        
    }
    else if (_currentIndex == 1)
    {
        _currentIndex = 0;
        _areaId = 0;
        _cityId = 0;
        _prodId = 0;
        _backCity = nil;
        _backProd = nil;
        _backArea =nil;
        [_tableView reloadData];
    }
    else
    {
        _prodId = 0;
        _cityId = 0;
        _areaId = 0;
        _backCity = nil;
        _backProd = nil;
        _backArea =nil;
        self.hidden = YES;
    }
}
-(void)ensure
{
    if (_prodId == 0 )
    {
        [MBProgressHUD showError:@"请选择" toView:self];
    }
    if (_cityId == 0&& _currentProvince.cityArray && _currentProvince.cityArray.count>0)
    {
        [MBProgressHUD showError:@"请继续选择" toView:self];
    }
    
    
    
    if (_firstPage != 1)
    {
        if (_areaId == 0 &&_currentCity.areaArray && _currentCity.areaArray.count>0)
        {
            [MBProgressHUD showError:@"请继续选择" toView:self];
        }
        else
        {
            NSString * str;
            if (_backProd)
            {
                str = _backProd;
            }
            if (_backCity)
            {
                str = [NSString stringWithFormat:@"%@ %@",str,_backCity];
            }
            if (_backArea)
            {
                str = [NSString stringWithFormat:@"%@ %@",str,_backArea];
            }
            if (_locaBlock)
            {
                _locaBlock(_prodId,_cityId,_areaId,str);
            }
            _currentIndex =0;
            self.hidden = YES;
        }
    }
    else
    {
        NSString * str;
        if (_backProd)
        {
            str = _backProd;
        }
        if (_backCity)
        {
            str = [NSString stringWithFormat:@"%@ %@",str,_backCity];
        }
        if (_backArea)
        {
            str = [NSString stringWithFormat:@"%@ %@",str,_backArea];
        }
        if (_locaBlock)
        {
            _locaBlock(_prodId,_cityId,_areaId,str);
        }
        
        _currentIndex =0;
        self.hidden = YES;
    }
    NSLog(@"_prodId == %ld,_cityId == %ld,_areaId == %ld",_prodId,_cityId,_areaId);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _currentIndex = 0;
    _areaId = 0;
    _cityId = 0;
    _prodId = 0;
    _backArea = nil;
    _backCity = nil;
    _backProd = nil;
    self.hidden = YES;
}

@end

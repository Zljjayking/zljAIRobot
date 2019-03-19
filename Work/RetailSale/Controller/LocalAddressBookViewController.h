//
//  LocalAddressBookViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/8/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface LocalAddressBookViewController : BaseViewController<
UITableViewDelegate, UITableViewDataSource,
UISearchBarDelegate, UISearchDisplayDelegate >
@property (strong, nonatomic) UISearchController *searchController;
@end

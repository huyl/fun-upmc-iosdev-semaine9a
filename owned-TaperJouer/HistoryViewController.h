//
//  DetailViewController.h
//  owned-TaperJouer
//
//  Created by Huy on 7/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

@class MainViewController;

@interface HistoryViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RACSubject *trackSelectedSignal;

- (instancetype)initWithViewModel:(ViewModel *)viewModel;

@end

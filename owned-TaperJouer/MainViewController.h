//
//  MasterViewController.h
//  owned-TaperJouer
//
//  Created by Huy on 7/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

@class HistoryViewController;

@interface MainViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, weak) HistoryViewController *historyVC;

- (instancetype)initWithViewModel:(ViewModel *)viewModel;

@end

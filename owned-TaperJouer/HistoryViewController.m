//
//  DetailViewController.m
//  owned-TaperJouer
//
//  Created by Huy on 7/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "Masonry.h"
#import "HistoryViewController.h"
#import "MainViewController.h"

@interface HistoryViewController ()

@property (nonatomic, weak) ViewModel *viewModel;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HistoryViewController

- (instancetype)initWithViewModel:(ViewModel *)viewModel
{
    self = [self init];
    if (self) {
        _viewModel = viewModel;
        _trackSelectedSignal = [RACSubject subject];
        
        self.title = @"Historique";
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
        self.tabBarItem.title = @"Historique";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// Table View

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    // Give more breathing room (esp. under iOS 7) underneath the status bar
    tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
    self.tableView = tableView;
    [tableView reloadData];
    
    
    [self setupRAC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RAC

- (void)setupRAC
{
    @weakify(self);
    
    // React to new track
    [self.viewModel.trackHistoryUpdatedSignal subscribeNext:^(NSArray *tracks) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tracks = self.viewModel.trackHistory;
    [self.trackSelectedSignal sendNext:tracks[indexPath.section][indexPath.row]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel.trackHistory count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.viewModel.trackHistory objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"any";
    
    // NOTE: must not use `forIndexPath:` variant if you want to do UITableViewCellStyleSubtitle programmatically
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *tracks = self.viewModel.trackHistory;
    MPMediaItem *track = tracks[indexPath.section][indexPath.row];
    cell.textLabel.text = [track valueForProperty:MPMediaItemPropertyTitle];

    // Assume that there is no artwork for the media item.
	UIImage *artworkImage = self.viewModel.noArtworkImage;
	
	// Get the artwork from the current media item, if it has artwork.
	MPMediaItemArtwork *artwork = [track valueForProperty:MPMediaItemPropertyArtwork];
	
	// Obtain a UIImage object from the MPMediaItemArtwork object
	if (artwork) {
		artworkImage = [artwork imageWithSize:cell.imageView.frame.size];
	}
	
    cell.imageView.image = artworkImage;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

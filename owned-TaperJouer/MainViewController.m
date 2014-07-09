//
//  MasterViewController.m
//  owned-TaperJouer
//
//  Created by Huy on 7/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "Masonry.h"
#import "MainViewController.h"
#import "HistoryViewController.h"

@interface MainViewController ()

@property (nonatomic, weak) ViewModel *viewModel;

@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UILabel *trackLabel;
@property (nonatomic, weak) UILabel *indexLabel;
@property (nonatomic, weak) UITextView *instructionsView;
@property (nonatomic, weak) UIProgressView *progress;
@property (nonatomic, weak) UIImageView *artView;

@property (nonatomic, weak) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, weak) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, weak) UISwipeGestureRecognizer *rightSwipe;

@property (nonatomic, strong) MPMusicPlayerController *player;

@property (nonatomic, strong) RACSubject *playSignal;
@property (nonatomic, strong) RACSubject *trackChangedSignal;

@end

@implementation MainViewController

- (instancetype)initWithViewModel:(ViewModel *)viewModel
{
    self = [self init];
    if (self) {
        _viewModel = viewModel;
        
        self.title = @"Musique";
        
        UIImage *image = [UIImage imageNamed:@"tete-a-toto.png"];
        self.tabBarItem.image = [UIImage imageWithCGImage:[image CGImage]
                                                    scale:(image.scale * 146/30)
                                              orientation:image.imageOrientation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    /// Controls
    
    UILabel *statusLabel = [[UILabel alloc] init];
    _statusLabel = statusLabel;
    statusLabel.text = @"-";
    statusLabel.textColor = [UIColor grayColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLabel];
    
    UILabel *trackLabel = [[UILabel alloc] init];
    _trackLabel = trackLabel;
    trackLabel.text = @"-";
    trackLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:trackLabel];
    
    UIProgressView *progress = [[UIProgressView alloc] init];
    _progress = progress;
    [self.view addSubview:progress];
    
    UILabel *indexLabel = [[UILabel alloc] init];
    _indexLabel = indexLabel;
    indexLabel.text = @"- / -";
    indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:indexLabel];
    
    UIImageView *artView = [[UIImageView alloc] init];
    _artView = artView;
    [self.view addSubview:artView];
    
    // Instructions must be added after artView to be overlayed on top
    UITextView *instructionsView = [[UITextView alloc] init];
    _instructionsView = instructionsView;
    instructionsView.text = @"\n\nDouble-click to play/pause\nSwipe to go to next song";
    instructionsView.textAlignment = NSTextAlignmentCenter;
    instructionsView.editable = NO;
    if ([instructionsView respondsToSelector:@selector(setSelectable:)]) {
        // iOS 7+
        instructionsView.selectable = NO;
    }
    instructionsView.textColor = [UIColor grayColor];
    instructionsView.backgroundColor = [UIColor colorWithRed:0.940 green:0.937 blue:0.905 alpha:1.000];
    [self.view addSubview:instructionsView];
    
    /// Gesture recognizers
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    _doubleTapRecognizer = doubleTapRecognizer;
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] init];
    _leftSwipe = leftSwipe;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] init];
    _rightSwipe = rightSwipe;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
    /// Media player
    
#if !(TARGET_IPHONE_SIMULATOR)
    self.player = [MPMusicPlayerController applicationMusicPlayer];
    
    // By default, an application music player takes on the shuffle and repeat modes
    //		of the built-in iPod app. Here they are both turned off.
    self.player.shuffleMode = MPMusicShuffleModeOff;
    self.player.repeatMode = MPMusicRepeatModeNone;
    
    [_player setQueueWithQuery:self.viewModel.tracksQuery];
    
    [self registerForMediaPlayerNotifications];
#endif
    
    /// RAC
    
    [self setupRAC];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // Update constraints on init and orientation changes
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    UIView *superview = self.view;
    
    // Config
    UIEdgeInsets padding;
    UIOffset internal;
    if (superview.bounds.size.height >= 480) {
        padding = UIEdgeInsetsMake(90, 15, 15, 15);
        internal = UIOffsetMake(20, 20);
    } else {
        padding = UIEdgeInsetsMake(40, 10, 10, 10);
        internal = UIOffsetMake(10, 10);
    }
    
    [self.progress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(padding.top);
        make.left.equalTo(superview).with.offset(2 * padding.left);
        make.right.equalTo(superview).with.offset(-2 * padding.right);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progress.mas_bottom).with.offset(internal.vertical);
        make.centerX.equalTo(superview);
    }];
    
    [self.indexLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel);
        make.right.equalTo(superview).with.offset(-padding.right);
        make.width.equalTo(@80);
    }];
    
    [self.trackLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(internal.vertical);
        make.centerX.equalTo(superview);
    }];
    
    [self.instructionsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackLabel.mas_bottom).with.offset(3 * internal.vertical);
        make.width.and.centerX.equalTo(superview);
        make.height.equalTo(@100);
    }];
    
    [self.artView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackLabel.mas_bottom).with.offset(2 * internal.vertical);
        make.centerX.equalTo(superview);
        make.width.and.height.equalTo(@240);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - RAC

- (void)setupRAC
{
    @weakify(self);
    
    self.playSignal = [RACSubject subject];
    self.trackChangedSignal = [RACSubject subject];
    
    // Respond to double taps to play/pause music
    [self.doubleTapRecognizer.rac_gestureSignal subscribeNext:^(UIGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        
        if (self.player.playbackState == MPMusicPlaybackStatePlaying) {
            [self.player pause];
        } else {
            [self.player play];
        }
    }];
    
    // Respond to swipes to change tracks
    // NOTE: combining the two recognizers doesn't work
    [self.leftSwipe.rac_gestureSignal subscribeNext:^(UISwipeGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        if (self.player.indexOfNowPlayingItem + 1 < self.viewModel.numTracks) {
            [self.player skipToNextItem];
        }
    }];
    [self.rightSwipe.rac_gestureSignal subscribeNext:^(UISwipeGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        if (self.player.indexOfNowPlayingItem > 0) {
            [self.player skipToPreviousItem];
        }
    }];
    
    // Respond to changing track (from history)
    [self.historyVC.trackSelectedSignal subscribeNext:^(MPMediaItem *track) {
        @strongify(self);
        
        self.player.nowPlayingItem = track;
        [self.player play];
        
        if (self.tabBarController) {
            // For iPhone, switch to this view
            self.tabBarController.selectedViewController = self.navigationController;
        }
        if (self.splitViewController) {
            // For iPad, close master view
            [[UIApplication sharedApplication] sendAction:self.navigationItem.leftBarButtonItem.action
                                                       to:self.navigationItem.leftBarButtonItem.target
                                                     from:nil
                                                 forEvent:nil];
        }
    }];
    
    // React in order to add to history
    // - Combine 2 signals: whenever the user hits play and whenever the track changes (because of swiping or
    // selecting from history).
    // - Only care if a track is playing
    // - Only care if the track name has changed (disctint)
    [[[[[self.playSignal
         combineLatestWith:self.trackChangedSignal]
        filter:^BOOL(id value) {
            @strongify(self);
            // NOTE: the playSignal's value doesn't matter; it just emits whenever the user hits play.
            // We still need to check the current state
            return self.player.playbackState == MPMusicPlaybackStatePlaying;
        }]
       map:^id(RACTuple *tuple) {
           return tuple[1];
       }]
      distinctUntilChanged]
     subscribeNext:^(MPMediaItem *track) {
         @strongify(self);
         [self.viewModel addTrackToHistory:track];
     }];
    
    // Update the progress bar every second
    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        float time = self.player.currentPlaybackTime;
        NSNumber *durationNumber = [self.player.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration];
        float percent = durationNumber == nil || durationNumber.floatValue == 0 ? 0 : time / durationNumber.floatValue;
        [self.progress setProgress:percent animated:YES];
    }];
}

#pragma mark - Media Player Notifications

// TODO: Change to ReactiveCocoa
- (void)registerForMediaPlayerNotifications {
    
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver:self
						   selector:@selector(handle_NowPlayingItemChanged:)
							   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object:self.player];
	
	[notificationCenter addObserver:self
						   selector:@selector(handle_PlaybackStateChanged:)
							   name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object:self.player];
    
	[self.player beginGeneratingPlaybackNotifications];
}

- (void)handle_PlaybackStateChanged:(id)notification
{
    if (self.player.playbackState == MPMusicPlaybackStatePlaying) {
        self.statusLabel.text = @"écoute";
        self.instructionsView.hidden = YES;
        [self.playSignal sendNext:@(self.player.playbackState)];
    } else {
        self.statusLabel.text = @"arrêt";
        self.instructionsView.hidden = NO;
    }
    
    [self updateIndexLabel];
}


// When the now-playing item changes, update the media item artwork and the now-playing label.
- (void) handle_NowPlayingItemChanged: (id)notification
{
	MPMediaItem *currentItem = [self.player nowPlayingItem];
    
	// Assume that there is no artwork for the media item.
	UIImage *artworkImage = self.viewModel.noArtworkImage;
	
	// Get the artwork from the current media item, if it has artwork.
	MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
	
	// Obtain a UIImage object from the MPMediaItemArtwork object
	if (artwork) {
		artworkImage = [artwork imageWithSize:self.artView.frame.size];
	}
	
	self.artView.image = artworkImage;
    
	// Display the song name for the now-playing media item
	NSString *track = [currentItem valueForProperty:MPMediaItemPropertyTitle];
	self.trackLabel.text = track != nil ? track : @"-";
    
    if (self.player.nowPlayingItem) {
        [self.trackChangedSignal sendNext:self.player.nowPlayingItem];
    }
    
    [self updateIndexLabel];
}

- (void)updateIndexLabel
{
    // Update the track number(s)
    if (self.player.indexOfNowPlayingItem != NSNotFound) {
        self.indexLabel.text = [NSString stringWithFormat:@"%d / %d",
                                (self.player.indexOfNowPlayingItem + 1), self.viewModel.numTracks];
    } else {
        self.indexLabel.text = [NSString stringWithFormat:@"- / %d", self.viewModel.numTracks];
    }
}

#pragma mark - Misc

- (void)showNavigationButton:(UIBarButtonItem *)barButtonItem
{
    barButtonItem.title = @"Historique";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)hideNavigationButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - UISplitViewControllerDelegate methods

/* This is the same as the default
- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    // Hide the history if in portrait mode
    return orientation == UIInterfaceOrientationMaskPortrait;
}
 */

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    [self showNavigationButton:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self hideNavigationButton];
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

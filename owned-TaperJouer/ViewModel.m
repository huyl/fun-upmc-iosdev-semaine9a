//
//  ViewModel.m
//  owned-TaperJouer
//
//  Created by Huy on 7/5/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel ()

@end


@implementation ViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _noArtworkImage = [UIImage imageNamed:@"no_artwork.png"];
        
        _tracksQuery = [MPMediaQuery songsQuery];
        
        _trackHistory = [[NSMutableArray alloc] init];
        [_trackHistory addObject:[[NSMutableArray alloc] init]];
        
        _trackHistoryUpdatedSignal = [RACSubject subject];
    }
    return self;
}

- (int)numTracks
{
    return [self.tracksQuery.collections count];
}

- (void)addTrackToHistory:(MPMediaItem *)track
{
    if (track) {
        [self.trackHistory[0] addObject:track];
        [self.trackHistoryUpdatedSignal sendNext:@0];
    }
}

@end

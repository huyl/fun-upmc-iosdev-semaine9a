//
//  ViewModel.h
//  owned-TaperJouer
//
//  Created by Huy on 7/5/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property (nonatomic, readonly) MPMediaQuery *tracksQuery;
@property (nonatomic, readonly) int numTracks;
@property (nonatomic, strong) NSMutableArray *trackHistory;

@property (nonatomic, strong) RACSubject *trackHistoryUpdatedSignal;

@property (nonatomic, strong) UIImage *noArtworkImage;

- (void)addTrackToHistory:(MPMediaItem *)track;


@end

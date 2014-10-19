//
//  PDOpenings.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.


#import <Foundation/Foundation.h>

@interface PDOpenings : NSObject

@property (nonatomic) BOOL isOpenNorth;
@property (nonatomic) BOOL isOpenEast;
@property (nonatomic) BOOL isOpenSouth;
@property (nonatomic) BOOL isOpenWest;

- (void) setIsOpenNorth:(BOOL)north East:(BOOL)east South:(BOOL)south West:(BOOL)west;

@end

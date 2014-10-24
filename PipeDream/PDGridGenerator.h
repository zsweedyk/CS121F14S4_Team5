//
//  PDGridGenerator.h
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCellModel.h"
#import "PDOpenings.h"

@interface PDGridGenerator : NSObject

+ (NSMutableArray *)generateGridForLevelNumber:(NSInteger)levelNumber;
+ (NSMutableArray *)generateGridFromString:(NSString*)string;

@end

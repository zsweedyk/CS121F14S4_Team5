//
//  PDPIDScenario.h
//  PipeDream
//
//  Created by CS121 on 12/1/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPIDScenario : NSObject

@property (nonatomic) NSString *personalIdentifier;
@property (nonatomic) NSArray *okMonsters;

- (id)initWithPID:(NSString *)pid andOkMonsters:(NSArray *)monsters;
- (BOOL)monsterIsOk:(NSString *)monster;

@end

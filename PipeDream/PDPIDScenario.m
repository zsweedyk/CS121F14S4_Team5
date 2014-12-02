//
//  PDPIDScenario.m
//  PipeDream
//
//  Created by CS121 on 12/1/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDPIDScenario.h"

@implementation PDPIDScenario

- (void)initWithPID:(NSString *)pid andOkMonsters:(NSArray *)monsters {
    self.personalIdentifier = pid;
    self.okMonsters = [NSArray arrayWithArray:monsters];
}

- (BOOL)monsterIsOk:(NSString *)monster {
    return [self.okMonsters containsObject:(NSString *)monster];
}

@end

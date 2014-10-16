//
//  PDLevelViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDLevelViewController.h"
#import "PDGridView.h"
#import "PDGridModel.h"

@interface PDLevelViewController ()

@property (nonatomic, strong) PDGridView *gridView;
@property (nonatomic, strong) PDGridModel *gridModel;

@end

@implementation PDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    // this method will be called when the gridView tells us, since we will be its delegate
}

@end

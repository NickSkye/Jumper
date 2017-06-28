//
//  GameData.m
//  FlippysFlight
//
//  Created by Dori Mouawad on 6/25/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

#import "GameData.h"

@implementation GameData

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)reset
{
    self.score = 0;
    self.distance = 0;
    self.coins = 0;
}

@end

//
//  GameData.m
//  FlippysFlight
//
//  Created by Dori Mouawad on 6/25/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

#import "GameData.h"

@implementation GameData

+ (instancetype)sharedGameData
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//Key variables for GameData
static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataTotalDistanceKey = @"totalDistance";
static NSString* const SSGameDataTotalCoinsKey = @"totalCoins";
static NSString* const SSGameDataNumTimesPlayedKey = @"numTimesPlayed";
static NSString* const SSGameDataTotalCoinsSpentKey = @"totalCoinsSpent";

//Encoder
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey:SSGameDataHighScoreKey];
    [encoder encodeDouble:self.totalDistance forKey: SSGameDataTotalDistanceKey];
    [encoder encodeDouble:self.totalCoins forKey:SSGameDataTotalCoinsKey];
    [encoder encodeDouble:self.numTimesPlayed forKey: SSGameDataNumTimesPlayedKey];
    [encoder encodeDouble:self.coinsSpent forKey:SSGameDataTotalCoinsSpentKey];
    
}

//Decoder
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self){
        _highScore = [aDecoder decodeDoubleForKey: SSGameDataHighScoreKey];
        _totalDistance = [aDecoder decodeDoubleForKey:SSGameDataTotalDistanceKey];
        _totalCoins = [aDecoder decodeDoubleForKey:SSGameDataTotalCoinsKey];
        _numTimesPlayed = [aDecoder decodeDoubleForKey:SSGameDataNumTimesPlayedKey];
        _totalCoinsSpent = [aDecoder decodeDoubleForKey:SSGameDataTotalCoinsSpentKey];
    }
    
    return self;
}

- (void)reset
{
    self.score = 0;
    self.distance = 0;
    self.coins = 0;
}

@end

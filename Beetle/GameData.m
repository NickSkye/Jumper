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
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

+ (NSString*) filePath
{
    static NSString* filePath = nil;
    if(!filePath){
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:@"gameData"];
    }
    return filePath;
}

+ (instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
    if (decodedData) {
        GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[GameData alloc] init];
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

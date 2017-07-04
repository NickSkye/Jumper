//
//  GameData.m
//  FlippysFlight
//
//  Created by Dori Mouawad on 6/25/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

#import "GameData.h"
#import "KeychainWrapper.h"

@implementation GameData

//Key variables for GameData
static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataTotalDistanceKey = @"totalDistance";
static NSString* const SSGameDataTotalCoinsKey = @"totalCoins";
static NSString* const SSGameDataNumTimesPlayedKey = @"numTimesPlayed";
static NSString* const SSGameDataTotalCoinsSpentKey = @"totalCoinsSpent";

//Key Variables for Keychain Wrapper Checksum
static NSString* const SSGameDataChecksumKey = @"SSGameDataChecksumKey";


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

//Load file instance from a file
+ (instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
    
    if (decodedData) {
        //Generates SHA256 has decoded checksum data from saved file
        NSString* checksumOfSavedFile = [KeychainWrapper computeSHA256DigestForData: decodedData];
        
        //Get most recent SHA256 checksum stored in the keychain
        NSString* checksumInKeychain = [KeychainWrapper keychainStringFromMatchingIdentifier: SSGameDataChecksumKey];

        //Compare both checksum data then return the game data if it matched
        //Else return blank/initiliazed data.
        if ([checksumOfSavedFile isEqualToString: checksumInKeychain]) {
            GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
            return gameData;
        }
    }
    
    return [[GameData alloc] init];
}

//Writing the data to a file atomically
- (void) save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[GameData filePath] atomically:YES];
    
    //Checksum for when saving data
    NSString* checksum = [KeychainWrapper computeSHA256DigestForData: encodedData];
    
    //If there is an exisiting keychain string, then update it. Else if it does not exit then create it
    if ([KeychainWrapper keychainStringFromMatchingIdentifier: SSGameDataChecksumKey]) {
        [KeychainWrapper updateKeychainValue:checksum forIdentifier:SSGameDataChecksumKey];
    } else {
        [KeychainWrapper createKeychainValue:checksum forIdentifier:SSGameDataChecksumKey];
    }
}



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

//
//  GameData.h
//  FlippysFlight
//
//  Created by Dori Mouawad on 6/25/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding>

//Instance Variables: Kept track locally in each game instance then added to Permanent variables below.
@property (assign, nonatomic) long score;
@property (assign, nonatomic) int distance;
@property (assign, nonatomic) int coins;
@property (assign, nonatomic) int coinsSpent;


//Permanent Variables: Calculated from data taken from instance variables, stored, and sent over iCloud. Users
//will see these in their profile section.
@property (assign, nonatomic) long highScore;
@property (assign, nonatomic) long totalDistance;
@property (assign, nonatomic) long totalCoins;
@property (assign, nonatomic) long numTimesPlayed;
@property (assign, nonatomic) long totalCoinsSpent;


//Defaults for Cocoa Touch Class
+(instancetype)sharedGameData;
-(void)reset;

@end

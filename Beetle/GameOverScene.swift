//
//  GameOverScene.swift
//  FlippysFlight
//
//  Created by Dori Mouawad on 9/5/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    var restartBtn = SKSpriteNode()
    
    init(size: CGSize, score:Int, tokens: Int){
        super.init(size : size)
        
        //Set backgroundColor
        backgroundColor = SKColor.white
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        let coinsLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        scoreLabel.text = "You Scored: \(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(scoreLabel)
        
        
        coinsLabel.text = "and collected \(tokens) coins"
        coinsLabel.fontSize = 20
        coinsLabel.fontColor = SKColor.black
        coinsLabel.position = CGPoint(x: size.width/2, y: size.height/2.5)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

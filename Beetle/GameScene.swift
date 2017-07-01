

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var tokens = Int(0)
    var running = Bool(false)
    var statLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var tokenLbl = SKLabelNode()
    var pauseBtn = SKSpriteNode()
    var shopBtn = SKSpriteNode()
    var profileBtn = SKSpriteNode()
   // var skinBtn = UIButton()
    var backBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
   var movePipes = SKAction()
    var distance = CGFloat()
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()
    var delay = SKAction()
    var SpawnDelay = SKAction()
    var spawnDelayForever = SKAction()
    var spawn = SKAction()
    var time = CGFloat()
    var pauseRestart = SKSpriteNode()
    
    //Instance of GameData
    var gameData: GameData = GameData()
    
    
    override func didMove(to view: SKView) {
        createScene()
        
        
        if UserDefaults.standard.object(forKey: "highestScore") != nil {
            print("ERROR1")
            let hscore = UserDefaults.standard.integer(forKey: "highestScore")
            if hscore < Int(scoreLbl.text!)!{
                UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
            }
        } else {
            UserDefaults.standard.set(0, forKey: "highestScore")
        }
        //for tokens ; currenttokens means all they have to spend ; tokens is what they have this round
        if UserDefaults.standard.object(forKey: "currentTokens") != nil {
            print("ERROR2")
            var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
            var totaltokens = Int(currtokens) + tokens
            UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
            
        } else {
            UserDefaults.standard.set(0, forKey: "currentTokens")
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("1")
        
        
        // Create the method you want to call (see target before)
        
        // put all menu items on scene here as else if using same notation. CTRL-f menu items to find where to remove them on this page
        //THIS FIRST IF ENSURES IT DOESNT CRASH
        if type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKLabelNode()) && type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKShapeNode()) {
        if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == shopBtn {
            let skinscene = ShopScene(size: (view?.bounds.size)!)
            let skinskView = view!
            skinskView.showsFPS = false
            skinskView.showsNodeCount = false
            skinskView.ignoresSiblingOrder = false
            skinscene.scaleMode = .resizeFill
            skinskView.presentScene(skinscene, transition: SKTransition.doorway(withDuration: 1))
            shopBtn.removeFromParent()
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == profileBtn {
            let profilescene = ProfileScene(size: (view?.bounds.size)!)
            let profileskView = view!
            profileskView.showsFPS = false
            profileskView.showsNodeCount = false
            profileskView.ignoresSiblingOrder = false
            profilescene.scaleMode = .resizeFill
            profileskView.presentScene(profilescene, transition: SKTransition.doorway(withDuration: 1))
            profileBtn.removeFromParent()
        }
        }        //
        
        
        
        if gameStarted == false{
            MusicHelper.sharedHelper.playBackgroundMusic()
            gameStarted =  true
            
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
             //   self.skinBtn.removeFromParent()
                 print("2")
          
                
            })
            //menu items remove here
            shopBtn.removeFromParent()
            profileBtn.removeFromParent()
            
            taptoplayLbl.removeFromParent()
            shopBtn.removeAllActions()
            profileBtn.removeAllActions()
           
            self.bird.run(repeatActionbird)
            
             spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
                
                
            })
            
            
            
            delay = SKAction.wait(forDuration: 1.5)
            SpawnDelay = SKAction.sequence([spawn, delay])
            spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            distance = CGFloat(self.frame.width + wallPair.frame.width)
            ///
            //print(distance)
            movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            if died == false {
                //change speed and shit here
                 print("3")
                
                
                
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
               //
                distance = CGFloat(self.frame.width + wallPair.frame.width)
                if score < 75 {
                    time = (0.008 * distance) - (CGFloat(score)/25.0)
                }
                else {
                    time = 2.168
                }
                movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(time))
                let removePipes = SKAction.removeFromParent()
                moveAndRemove = SKAction.sequence([movePipes, removePipes])
            }
        }
        
        /// was here V
        ///moved touches here
        for touch in touches{
            let location = touch.location(in: self)
            //let node = self.nodes(at: location)
            if died == true{
                if restartBtn.contains(location){
                    //for score
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        print("ERROR1")
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    //for tokens ; currenttokens means all they have to spend ; tokens is what they have this round
                    if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                        print("ERROR2")
                        var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                        var totaltokens = Int(currtokens) + tokens
                        UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                        
                    } else {
                        UserDefaults.standard.set(0, forKey: "currentTokens")
                    }

                    
                    restartScene()
                }
            } else if pauseBtn.contains(location){
                if self.isPaused == false{
                    self.isPaused = true
                    // MusicHelper.sharedHelper.stopBackgroundMusic()
                    pauseBtn.texture = SKTexture(imageNamed: "play")
                    ////////////
                    pauseRestart = SKSpriteNode(imageNamed: "restart")
                    pauseRestart.size = CGSize(width:60, height:40)
                    pauseRestart.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY)
                    pauseRestart.zPosition = 9
                    pauseRestart.name = "pauseRestart"
                    pauseRestart.isHidden = false
                   
                    self.addChild(pauseRestart)
                    print("HERE")
                    
                    
                    
                  
                    /////////
                    
                    
                } else {
                    pauseRestart.isHidden = true
                    pauseRestart.removeFromParent()
                    pauseRestart.removeAllChildren()
                    pauseRestart.removeAllActions()
                    self.isPaused = false
                    
                    //  MusicHelper.sharedHelper.playBackgroundMusic()
                    pauseBtn.texture = SKTexture(imageNamed: "pause")
                    
                }
            }
                //use contains and an ishidden check to use this method
            else if pauseRestart.contains(location) && pauseRestart.isHidden == false{
                print("YESY")
                pauseRestart.removeFromParent()
                self.isPaused = false
                pauseRestart.isHidden = true
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    }
                } else {
                    UserDefaults.standard.set(0, forKey: "highestScore")
                }
                
                //for tokens ; currenttokens means all they have to spend ; tokens is what they have this round
                if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                    var totaltokens = Int(currtokens) + tokens
                    UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                    
                } else {
                    UserDefaults.standard.set(0, forKey: "currentTokens")
                }

                
                restartScene()
                
            }
/*
            else if (nodes(at: touch.location(in: self))[0] as? SKSpriteNode) == shopBtn {
                let skinscene = SkinsScene(size: (view?.bounds.size)!)
                let skinskView = view!
                skinskView.showsFPS = false
                skinskView.showsNodeCount = false
                skinskView.ignoresSiblingOrder = false
                skinscene.scaleMode = .resizeFill
                skinskView.presentScene(skinscene, transition: SKTransition.doorway(withDuration: 2))
                shopBtn.removeFromParent()
            } */
            
            
        }
        
        ////
        //////
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        tokens = 0
        gameData.reset()
        createScene()
    }
    
    func createSkinScene() {
        let background = SKSpriteNode(imageNamed: "newBG")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        //background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        createBackBtn()
    }
    
    func createScene(){
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        let hour = Calendar.current.component(.hour, from: Date())
        print("hour \(hour)")
        for i in 0..<2 {
            var background = SKSpriteNode(imageNamed: "bg")
            if hour > 19 || hour < 7 {
                background = SKSpriteNode(imageNamed: "newBG")
            }
            
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            //DONT KNOW WHY ADDING THIS makes it alternate backgrounds
            /*
            let secondBG = SKSpriteNode(imageNamed: "newBG")
            secondBG.anchorPoint = CGPoint.init(x: 0, y: 0)
            secondBG.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            secondBG.name = "secondBG"
            secondBG.size = (self.view?.bounds.size)!
            self.addChild(secondBG)
            */
            
        }
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animatebird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionbird = SKAction.repeatForever(animatebird)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        scoreLbl.isUserInteractionEnabled = false
        tokenLbl = createTokenCollectedLabel()
        self.addChild(tokenLbl)
        tokenLbl.isUserInteractionEnabled = false
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)

        //create menu buttons here
        createLogo()
        //skin
        createShopBtn()
        createProfileBtn()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
         print("5")
      /*  if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } */
        if bird.position.x < 0 + bird.size.width/2 {
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
        }
         else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            tokens += 1
            tokenLbl.text = "\(tokens)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            tokens += 1
            tokenLbl.text = "\(tokens)"
            firstBody.node?.removeFromParent()
        }  else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.boostCategory {
            //BOOST HIT
            run(coinSound) //boostsound
            //do something
            
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.boostCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //BOOST HIT
            run(coinSound) //boostsound
            //do something
            
            firstBody.node?.removeFromParent()
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var bgImg = "background"
        
    
        
        if gameStarted == true{
            if died == false{
               /* if score > 10 {
                    bgImg = "backgroundTwo"
                } */
            
                    enumerateChildNodes(withName: bgImg, using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                        self.score += 1
                        self.scoreLbl.text = "\(self.score)"
                        
                    }
                }))
                //let distance = CGFloat(self.frame.width + wallPair.frame.width)
            //    let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval((0.008 * distance) - (CGFloat)(score/100)))
            }
        }
    }
    
    /*
     processScore: 
        Does not return a value. Meant to be run while the game is being played and the score change
     */
    func processScore(){
        //Set hScore as the value that stores the users highest score
        let hScore = gameData.highScore
            
        //Check if the users high score is greater than the score they currently have in-game
        //If high score is less than current score then reset the high score to match the current score.
        if hScore < Int(scoreLbl.text!)!{
                
            //Set current in-game score to a variable to be used for setting the high score
            let cScore = Int(scoreLbl.text!)
            gameData.highScore = cScore!
        }
        

    }
    
    /*
     processTokens:
        Does not return a value. Meant to be run while the game is being played and the token count changes when
     collected
     */
    func processTokens(){
        
        let cTokens = gameData.coins
        let tTokens = gameData.totalCoins + Int(cTokens)
            
        gameData.totalCoins = Int(tTokens)

    }
}












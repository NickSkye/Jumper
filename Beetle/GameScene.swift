

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    let teleport = SKAction.playSoundFileNamed("teleport.mp3", waitForCompletion: false)
    let scream = SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false)
    let saberSound = SKAction.playSoundFileNamed("saber.mp3", waitForCompletion: false)
    let hawk = SKAction.playSoundFileNamed("hawk.mp3", waitForCompletion: false)
    let chomp = SKAction.playSoundFileNamed("chomp.mp3", waitForCompletion: false)
    let pop = SKAction.playSoundFileNamed("bubblepop.mp3", waitForCompletion: false)
    
    var hardTouch = false
    var force = CGFloat()
    var score = Int(0)
    var invincibleCounter = Int(0)
    let invincibleBall = SKShapeNode()
    var invincible = false
    var tokens = Int(0)
    //let notificationName = Notification.Name("NotificationIdentifier")
    var running = Bool(false)
    var birdType = "bird1"
    var statLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var adBtn = SKSpriteNode()
    var secondChanceBtn = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var tokenLbl = SKLabelNode()
    var pauseBtn = SKSpriteNode()
    var shopBtn = SKSpriteNode()
    var profileBtn = SKSpriteNode()
    var gcBtn = SKSpriteNode()
    var background = SKSpriteNode(imageNamed: "city")
   // var skinBtn = UIButton()
    var backBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var bigBirdObstacle = SKNode()
    var moveAndRemove = SKAction()
    var moveAndRemoveBigBird = SKAction()
   var movePipes = SKAction()
    var moveBigBird = SKAction()
    var distance = CGFloat()
    var distanceBigBird = CGFloat()
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()

    var repeatActionbird = SKAction()
    var delay = SKAction()
    var delayBigBird = SKAction()
    var SpawnDelay = SKAction()
    var SpawnDelayBigBird = SKAction()
    var spawnDelayForever = SKAction()
    var spawnDelayBigBirdForever = SKAction()
    var spawn = SKAction()
    var spawnBigBird = SKAction()
    var time = CGFloat()
    var timeBigBird = CGFloat()
    var pauseRestart = SKSpriteNode()
    var feedback = UIImpactFeedbackGenerator(style: .heavy)
    
    //Instance of GameData
    var gameData: GameData = GameData()
    var isTouching = false
    
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
            skinskView.presentScene(skinscene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
            shopBtn.removeFromParent()
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == profileBtn {
            let profilescene = ProfileScene(size: (view?.bounds.size)!)
            let profileskView = view!
            profileskView.showsFPS = false
            profileskView.showsNodeCount = false
            profileskView.ignoresSiblingOrder = false
            profilescene.scaleMode = .resizeFill
            profileskView.presentScene(profilescene, transition: SKTransition.push(with: .down, duration: 1))
            profileBtn.removeFromParent()
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == gcBtn {
            let gcscene = GameCenterScene(size: (view?.bounds.size)!)
            let gckView = view!
            gckView.showsFPS = false
            gckView.showsNodeCount = false
            gckView.ignoresSiblingOrder = false
            gcscene.scaleMode = .resizeFill
            gckView.presentScene(gcscene, transition: SKTransition.push(with: .left, duration: 1))
            gcBtn.removeFromParent()
            }
        
        }        //
        
        
        ////////////////////////////////WAS HERE
        
        
        /// was here V
        ///moved touches here
        
        for touch in touches{
            
            let location = touch.location(in: self)
            force = touch.force
            
           print("force \(force)")
            print("maxforce \(touch.maximumPossibleForce)")
            //let node = self.nodes(at: location)
            if force >= 0.01 {
                hardTouch = true
                print("HARDTRUE")
            }
            else {
                hardTouch = false
            }
            //////////////MOVED HERE
            if gameStarted == false{
                isTouching = true
                MusicHelper.sharedHelper.playBackgroundMusic()
                gameStarted =  true
                
                bird.physicsBody?.affectedByGravity = true
                createPauseBtn()
                
                logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                    self.logoImg.removeFromParent()
                    //   self.skinBtn.removeFromParent()
                    
                    
                    
                })
                //menu items remove here
                shopBtn.removeFromParent()
                profileBtn.removeFromParent()
                gcBtn.removeFromParent()
                taptoplayLbl.removeFromParent()
                shopBtn.removeAllActions()
                profileBtn.removeAllActions()
                
                self.bird.run(repeatActionbird)
                
                
                //spawns and creates pipes/walls and all items such as coins and boosts and sabers
                spawn = SKAction.run({
                    () in
                    self.wallPair = self.createWalls()
                    self.addChild(self.wallPair)
                    
                    
                })
                ///maybe delete this and just spawn them randomly in ^ spawn
                spawnBigBird = SKAction.run({
                    () in
                    self.bigBirdObstacle = self.createBigBird()
                    self.addChild(self.bigBirdObstacle)
                    
                    
                })
                
                
                //runs spawn and creates new pipes/walls and all items such as coins and boosts and sabers
                delay = SKAction.wait(forDuration: 1.5)
                SpawnDelay = SKAction.sequence([spawn, delay])
                spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                self.run(spawnDelayForever)
                
                //runs spawn and creates Big Bird
                
                delayBigBird = SKAction.wait(forDuration: 1.5)
                SpawnDelayBigBird = SKAction.sequence([spawnBigBird, delayBigBird])
                spawnDelayBigBirdForever = SKAction.repeatForever(SpawnDelayBigBird)
                self.run(spawnDelayBigBirdForever)
                
                
                //moves pipes/walls and all items such as coins and boosts and sabers across and off the screen
                distance = CGFloat(self.frame.width + wallPair.frame.width)
                movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
                let removePipes = SKAction.removeFromParent()
                moveAndRemove = SKAction.sequence([movePipes, removePipes])
                
                
                //moves Big Bird
                distanceBigBird = CGFloat(self.frame.width + bigBirdObstacle.frame.width)
                moveBigBird = SKAction.moveBy(x: -distanceBigBird - 50, y: 0, duration: TimeInterval(0.008 * distanceBigBird))
                let removeBigBird = SKAction.removeFromParent()
                moveAndRemoveBigBird = SKAction.sequence([moveBigBird, removeBigBird])
                
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
                /*
                if hardTouch == true {
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.051 * self.frame.height)))
                    print("hardTouch")
                } else {
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
                } */
            } else {
                if died == false {
                    //change speed and shit here
                    isTouching = true
                    
                    force = touch.force
                    
                    print("force \(force)")
                    print("maxforce \(touch.maximumPossibleForce)")
                    //let node = self.nodes(at: location)
                    if force >= 0.01 {
                        hardTouch = true
                        print("HARDTRUE")
                    }
                    else {
                        hardTouch = false
                    }
                    
                    if self.bird.position.x > self.frame.width {
                        print("ERRORRRRR")
                    }
                    
                    
                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    /*
                    if hardTouch == true {
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.051 * self.frame.height)))
                    } else {
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
                    } */
                    
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
                    distance = CGFloat(self.frame.width + wallPair.frame.width)
                    
                    if score < 65 {
                        time = (0.008 * distance) - (CGFloat(score)/25.0)
                    }
                    else {
                        time = 1.112 //2.168
                    }
                    //moves pipes/walls and all items such as coins and boosts and sabers across and off the screen
                    movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(time))
                    let removePipes = SKAction.removeFromParent()
                    moveAndRemove = SKAction.sequence([movePipes, removePipes])
                    
                    //move big bird
                    
                    let randomBirdMove = Int(random(min: 0, max: 3))
                    if randomBirdMove == 2 {
                        moveBigBird = SKAction.moveBy(x: -(self.frame.width * 2), y: 250, duration: TimeInterval(time))
                    }
                    else if randomBirdMove == 1 {
                        moveBigBird = SKAction.moveBy(x: -(self.frame.width * 2), y: -250, duration: TimeInterval(time))
                    }
                    
                    let pauser = SKAction.wait(forDuration: 1)
                    
                    let removeBigBird = SKAction.removeFromParent()
                    
                    moveAndRemoveBigBird = SKAction.sequence([pauser, moveBigBird, removeBigBird])
                    
                }
            }
            
            
            ////////////////////////////////
            
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
                else if adBtn.contains(location){
                    //for score
                    ////////////////PUT AD HERE?
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
                    
                    
                    
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
                        var totaltokens = Int(currtokens) + (tokens * 2) //Gives double tokens if ad watched
                        UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                        
                    } else {
                        UserDefaults.standard.set(0, forKey: "currentTokens")
                    }
                    
                    
                    restartScene()
                
            } /*else if secondChanceBtn.contains(location){
                //for score
                ////////////////PUT AD HERE?
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
                extraChance()
                
                
            }
        
                 } */ }
        else if pauseBtn.contains(location){
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
    
    override func touchesEnded(_ touches: Set<UITouch>,
                      with event: UIEvent?){
        isTouching = false
        hardTouch = false
        
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        tokens = 0
        createScene()
    }
    
    func extraChance(){
        
        died = false
        gameStarted = true
        //remove restartBTN and adBtn
        self.removeChildren(in: [restartBtn, adBtn])
        self.bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
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
        print("CREATESCENECALLED")
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
            
            background = SKSpriteNode(imageNamed: "city")
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
        
        // CHECKS WHAT BIRD IS BEING USED
        //UserDefaults.standard.removeObject(forKey: "birdType")
        if UserDefaults.standard.object(forKey: "birdType") != nil {
            birdType = UserDefaults.standard.string(forKey: "birdType")!
        } else {
            UserDefaults.standard.set("bird1", forKey: "birdType")
        }
        
        //////
        print(UserDefaults.standard.string(forKey: "birdType")!)
        
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        if birdType == "bird1" {
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        }
        else if birdType == "ducky" {
            birdSprites.append(birdAtlas.textureNamed("ducky"))
            birdSprites.append(birdAtlas.textureNamed("ducky"))
            birdSprites.append(birdAtlas.textureNamed("ducky"))
            birdSprites.append(birdAtlas.textureNamed("ducky"))
        }
        else if birdType == "rainbowbird1" {
            birdSprites.append(birdAtlas.textureNamed("rainbowbird1"))
            birdSprites.append(birdAtlas.textureNamed("rainbowbird1"))
            birdSprites.append(birdAtlas.textureNamed("rainbowbird1"))
            birdSprites.append(birdAtlas.textureNamed("rainbowbird1"))
        }
        else if birdType == "steveBird1" {
            birdSprites.append(birdAtlas.textureNamed("steveBird1"))
            birdSprites.append(birdAtlas.textureNamed("steveBird2"))
            birdSprites.append(birdAtlas.textureNamed("steveBird3"))
            birdSprites.append(birdAtlas.textureNamed("steveBird4"))
            
        }
        else if birdType == "derpyBird1" {
            birdSprites.append(birdAtlas.textureNamed("derpyBird1"))
            birdSprites.append(birdAtlas.textureNamed("derpyBird1"))
            birdSprites.append(birdAtlas.textureNamed("derpyBird1"))
            birdSprites.append(birdAtlas.textureNamed("derpyBird1"))
            
        }
        else if birdType == "fatBird1" {
            birdSprites.append(birdAtlas.textureNamed("fatBird1"))
            birdSprites.append(birdAtlas.textureNamed("fatBird1"))
            birdSprites.append(birdAtlas.textureNamed("fatBird1"))
            birdSprites.append(birdAtlas.textureNamed("fatBird1"))
            
        }
        
        
        self.bird = createBird(birdType: birdType)
        self.addChild(bird)
        createInvincibleBall()
        invincibleBall.alpha = 0.0
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
        createGameCenterBtn()
        
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
        if bird.position.x <= 10 {
            
            if invincible {
                bird.run(SKAction .moveTo(x: self.frame.width * 0.3 , duration: 0.05))
                invincibleCounter = 5
                
            }
            else {
            
            
            feedback.impactOccurred()
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                run(scream)
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
            }
        }
        else if bird.position.x >= (self.frame.width * 0.75) {
            bird.position.x = self.frame.width * 0.74
        }
         else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            
            tokens += 1
            tokenLbl.text = "\(tokens)"
            feedback.impactOccurred()
            secondBody.node?.removeFromParent()
           
            
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            
            tokens += 1
            tokenLbl.text = "\(tokens)"
            feedback.impactOccurred()
            firstBody.node?.removeFromParent()
            
        }
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory {
            //GROUND
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
            
        } else if firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //GROUND
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (0.041 * self.frame.height)))
            
        }
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory {
            //PILLAR BOUNCE
            if bird.position.y < self.frame.height * 0.75 && secondBody.node?.name == "bottomwall" {
                bird.physicsBody?.applyImpulse(CGVector(dx: 2, dy: (0.041 * self.frame.height)))
                
            }
            
        } else if firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //PILLAR BOUNCE
           
            if bird.position.y < self.frame.height * 0.75 && firstBody.node?.name == "bottomwall" {
                bird.physicsBody?.applyImpulse(CGVector(dx: 2, dy: (0.041 * self.frame.height)))
                
            }
            
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.boostCategory {
            //BOOST HIT
            invincibleCounter = 0
            invincibleBall.fillColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(150.0 / 255.0), alpha: CGFloat(0.5))
            invincibleBall.alpha = 0.5
            run(teleport) //boostsound
            invincible = true            //do something
            //wallPair.run(SKAction .hide())
            feedback.impactOccurred()
            self.score += 2
            self.scoreLbl.text = "\(self.score)"
            //bird.physicsBody?.velocity = CGVector(dx: 70, dy: 0)
            bird.run(SKAction .moveTo(x: self.frame.width * 0.74 , duration: 0.05))
            
            
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.boostCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //BOOST HIT
            invincibleCounter = 0
            invincibleBall.fillColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(150.0 / 255.0), alpha: CGFloat(0.5))
            invincibleBall.alpha = 0.5
            run(teleport) //boostsound
            invincible = true
           // wallPair.run(SKAction .hide())
            feedback.impactOccurred()
            self.score += 2
            self.scoreLbl.text = "\(self.score)"
             bird.run(SKAction .moveTo(x: self.frame.width * 0.74 , duration: 0.05))
            firstBody.node?.removeFromParent()
        }
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.scoreCategory {
            //INCREASE SCORE
            print("GETTING HERE")
            if invincible {
                invincibleCounter += 1
            }
            self.score += 1
            self.scoreLbl.text = "\(self.score)"
            secondBody.node?.removeFromParent()
            if invincibleCounter >= 5 {
                invincible = false
                invincibleCounter = 0
                invincibleBall.alpha = 0.0
                run(pop)
                
            }

            
        } else if firstBody.categoryBitMask == CollisionBitMask.scoreCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //INCREASE SCORE
            print("GETTING HERE")
            if invincible {
                invincibleCounter += 1
            }
            self.score += 1
            self.scoreLbl.text = "\(self.score)"
            firstBody.node?.removeFromParent()
            if invincibleCounter >= 5 {
                invincible = false
                invincibleCounter = 0
                invincibleBall.alpha = 0.0
                run(pop) //makes popping sound
            }

        }
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.killerPillarCategory  && invincible == false {
            //killer Laser
            feedback.impactOccurred()
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                run(scream)
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
            
            
        } else if firstBody.categoryBitMask == CollisionBitMask.killerPillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory && invincible == false {
            //killer Laser
            feedback.impactOccurred()
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                run(scream)
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
            
        }
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.bigBirdCategory && invincible == false {
            //BIG BIRD
            
            feedback.impactOccurred()
            self.bird.removeFromParent()
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                run(chomp)
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
            
            
        } else if firstBody.categoryBitMask == CollisionBitMask.bigBirdCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory && invincible == false {
            //BIG BIRD
            feedback.impactOccurred()
            self.bird.removeFromParent()
            MusicHelper.sharedHelper.stopBackgroundMusic()
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                run(chomp)
                
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
                
            }
            
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
                
                if bird.position.x <= 10 {
                    if invincible {
                        bird.run(SKAction .moveTo(x: self.frame.width * 0.3 , duration: 0.05))
                        invincibleCounter = 5
                        feedback.impactOccurred()
                    }
                    else {
                    
                    feedback.impactOccurred()
                    MusicHelper.sharedHelper.stopBackgroundMusic()
                    enumerateChildNodes(withName: "wallPair", using: ({
                        (node, error) in
                        node.speed = 0
                        self.removeAllActions()
                    }))
                    if died == false{
                        run(scream)
                        died = true
                        createRestartBtn()
                        pauseBtn.removeFromParent()
                        self.bird.removeAllActions()
                        
                    }
                    }
                }
                else if bird.position.x >= (self.frame.width * 0.75) {
                    bird.position.x = self.frame.width * 0.74
                }
                
                if birdType == "fatBird1" {
                if isTouching {
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -1)) //2.5
                } else {
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (0.004755 * self.frame.height))) //0
                }
                } else {
                    if isTouching {
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (0.003397 * self.frame.height)))
                        /*
                        if hardTouch == true {
                            bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (0.009397 * self.frame.height)))
                            
                            
                            
                        } else {
                            bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (0.003397 * self.frame.height)))
                           
                        } */
                         //2.5
                    } else {
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0)) //0
                    }
                }
               
                if pauseRestart.isHidden == false && isPaused == false{
                    pauseRestart.isHidden = true
                    pauseRestart.removeFromParent()
                    pauseRestart.removeAllChildren()
                    pauseRestart.removeAllActions()
                    self.isPaused = false
                    
                    //  MusicHelper.sharedHelper.playBackgroundMusic()
                    pauseBtn.texture = SKTexture(imageNamed: "pause")
                }
                
 
                    enumerateChildNodes(withName: bgImg, using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                        //THIS IS WHERE BACKGROUND CHANGES WITH SCORE
                        
                        if self.score > 40 {
                        bg.texture = SKTexture(imageNamed: "newBG")
                        }
                         
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                       // bg.removeFromParent()
                        print("node")
                        //self.score += 1
                       // self.scoreLbl.text = "\(self.score)"
                        
                    }
                }))
                
               // print("Amount of nodes \(self.children.count)")
           
                
                /*
                //Unnecessary because the above function deletes all wallpairs and all the other items are children of wallpairs
                enumerateChildNodes(withName: "backgroundStuff", using: ({
                    (node, error) in
                    let bgstuff = node as! SKSpriteNode
                    //THIS IS WHERE BACKGROUND CHANGES WITH SCORE
                    
                   
                    bgstuff.position = CGPoint(x: bgstuff.position.x - 2, y: bgstuff.position.y)
                    if bgstuff.position.x <= -50 {
                        //bgstuff.position = CGPoint(x:bgstuff.position.x + bgstuff.size.width * 2, y:bgstuff.position.y)
                        bgstuff.removeFromParent()
                        print("node")
                        //self.score += 1
                        // self.scoreLbl.text = "\(self.score)"
                        
                    }
                }))
                */

                ////
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












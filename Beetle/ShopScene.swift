

import SpriteKit
import Foundation


class ShopScene: SKScene {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var skinBtn = SKSpriteNode()
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
    var backBtn = SKSpriteNode()
    var newSkinBtn = SKSpriteNode()
    var buyTokensBtn = SKSpriteNode()
    var freeTokenBtn = SKSpriteNode()
    let tokenshopLbl = SKLabelNode()
    var tokensshop = Int(0)
    
//add stuff to game elements such as createSkinsButton and then implement in createSkinScene.

    override func didMove(to view: SKView) {
        print("HERE")
        createShopScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("1")
        
        
        // Create the method you want to call (see target before)
        
        // put all menu items on scene here as else if using same notation. CTRL-f menu items to find where to remove them on this page
        if type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKLabelNode()) && type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKShapeNode()) && Variables.adAboutToPlay == false {
        if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == backBtn {
            let scene = GameScene(size: (view?.bounds.size)!)
            let skView = view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = false
            scene.scaleMode = .resizeFill
            skView.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == newSkinBtn {
            let scene = NewSkinScene(size: (view?.bounds.size)!)
            let skView = view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = false
            scene.scaleMode = .resizeFill
            skView.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyTokensBtn {
            let scene = BuyTokensScene(size: (view?.bounds.size)!)
            let skView = view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = false
            scene.scaleMode = .resizeFill
            skView.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == freeTokenBtn {
            //MusicHelper.sharedHelper.stopBackgroundMusic()
            Variables.adAboutToPlay = true
            
            Variables.loaderView.center = (self.view?.center)!
            
            self.view?.addSubview(Variables.loaderView)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
            
            
            
                       //for tokens ; currenttokens means all they have to spend ; tokens is what they have this round
            
                /*UserDefaults.standard.set((UserDefaults.standard.integer(forKey: "currentTokens") + 2), forKey: "currentTokens")
            tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
            tokenshopLbl.text = "\(tokensshop) Coins"*/
            
            //GameData.shared().currCoins = GameData.shared().currCoins + 2
            
            //Set local variable to iCloid
            tokensshop = GameData.shared().currCoins
            
            //Set label text to match local variable and amount from iCloud
            tokenshopLbl.text = "\(tokensshop) Coins"
            
            //Save data into iCloud
        
            GameData.shared().save()
        }
        
        //
        
        }
        
        /// was here V
        ///moved touches here
        for touch in touches{
            let location = touch.location(in: self)
            //let node = self.nodes(at: location)
            /* CHANGE THIS TO GO TO A NEW SCENE WITH NEW CHARACTERS
            if (nodes(at: touch.location(in: self))[0] as? SKSpriteNode) == shopBtn {
                let skinscene = SkinsScene(size: (view?.bounds.size)!)
                let skinskView = view!
                skinskView.showsFPS = false
                skinskView.showsNodeCount = false
                skinskView.ignoresSiblingOrder = false
                skinscene.scaleMode = .resizeFill
                skinskView.presentScene(skinscene, transition: SKTransition.doorway(withDuration: 2))
                shopBtn.removeFromParent()
            }
            */
            
        }
        
        ////
        //////
    }

    
    func createShopScene() {
        /*let hour = Calendar.current.component(.hour, from: Date())
        print("hour \(hour)")*/
        var background = SKSpriteNode(imageNamed: "city")
        /*if hour > 19 || hour < 7 {
            background = SKSpriteNode(imageNamed: "newBG")
        }*/
       // let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        //background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        createLogo()
        createBackBtn()
        createNewSkinBtn()
        createCoinsAmount()
        createBuyTokensBtn()
        createAdBtn()
        
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "shopLbl")
        logoImg.size = CGSize(width: (0.657 * self.frame.width), height: (0.204 * self.frame.height))
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.height * 0.9)
        logoImg.setScale(0.2)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 0.6, duration: 0.5))
    }
    
    func createAdBtn() {
        freeTokenBtn = SKSpriteNode(imageNamed: "free-coins-simple")
        freeTokenBtn.size = CGSize(width: (0.2422 * self.frame.width), height: (0.136 * self.frame.height))
        freeTokenBtn.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 2)
        freeTokenBtn.zPosition = 6
        
        self.addChild(freeTokenBtn)
        print("freeTokenBtnCreated")
    }
    
    func createCoinsAmount() {
        
        /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
            tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
        } else {
            tokensshop = 0
        }*/
        
        //Gets current tokens from GameData
        tokensshop = GameData.shared().currCoins
        
        tokenshopLbl.position = CGPoint(x: self.frame.width - (0.181 * self.frame.width) , y: self.frame.height - (0.068 * self.frame.height))
        if tokensshop < 1000 {
            tokenshopLbl.text = "\(tokensshop) Coins"
        } else {
            tokenshopLbl.text = "\((Double(tokensshop / 1000)).rounded())k Coins"
        }
        tokenshopLbl.zPosition = 5
        tokenshopLbl.fontSize = 20
        tokenshopLbl.fontName = "HelveticaNeue-Bold"
        self.addChild(tokenshopLbl)
    }

    func createBackBtn() {
        backBtn = SKSpriteNode(imageNamed: "backbutton")
        backBtn.size = CGSize(width:60, height:40)
        backBtn.position = CGPoint(x: self.frame.midX / 6, y: self.frame.height - 50)
        backBtn.zPosition = 8
        self.addChild(backBtn)
    }
    
    func createNewSkinBtn() {
        newSkinBtn = SKSpriteNode(imageNamed: "flippys-friends")
        newSkinBtn.size = CGSize(width: (0.242 * self.frame.width), height: (0.136 * self.frame.height))
        newSkinBtn.position = CGPoint(x: self.frame.width / 4, y: self.frame.height * 0.75)
        newSkinBtn.zPosition = 8
        self.addChild(newSkinBtn)
    }
    
    func createBuyTokensBtn() {
        buyTokensBtn = SKSpriteNode(imageNamed: "buy-coins")
        buyTokensBtn.size = CGSize(width: (0.242 * self.frame.width), height: (0.136 * self.frame.height))
        buyTokensBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.height * 0.75)
        buyTokensBtn.zPosition = 8
        self.addChild(buyTokensBtn)
    }
 }












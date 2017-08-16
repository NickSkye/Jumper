

import SpriteKit
import Foundation


class NewSkinScene: SKScene {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var buyFirstBtn = SKSpriteNode()
    var buySecondBtn = SKSpriteNode()
    var buyThirdBtn = SKSpriteNode()
    var buyFourthBtn = SKSpriteNode()
    var buyFifthBtn = SKSpriteNode()
    var buySixthBtn = SKSpriteNode()
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
    let tokenshopLbl = SKLabelNode()
    var characters = [String]()
    var birdInUse = String()
   
    
    //add stuff to game elements such as createSkinsButton and then implement in createSkinScene.
    
    override func didMove(to view: SKView) {
        characters = GameData.shared().purchased as! [String]
        
        print(characters)
        
      // UserDefaults.standard.removeObject(forKey: "characters")
        if (UserDefaults.standard.object(forKey: "birdType") as! String) != nil {
            birdInUse = UserDefaults.standard.object(forKey: "birdType") as! String
        }
        else {
            birdInUse = "bird1"
        }
        
       print(birdInUse)
        
        /*if UserDefaults.standard.array(forKey: "characters") != nil {
            
            characters = UserDefaults.standard.array(forKey: "characters") as! [String]
            
        } else {
            if characters.isEmpty {
                characters.append("bird1")
            }
            UserDefaults.standard.set(characters, forKey: "characters")
        }*/
        
        //Checks if array is empty and sets the character to the default character
        if characters.isEmpty {
            characters.append("bird1")
            
            //Adds "bird1" to the GameData purchased array, then save it to iCloud
            GameData.shared().purchased.add("bird1")
            GameData.shared().save()
            
            characters = GameData.shared().purchased as! [String]
        }
        
        createProfileScene()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // Create the method you want to call (see target before)
        
        // put all menu items on scene here as else if using same notation. CTRL-f menu items to find where to remove them on this page
        if type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKLabelNode()) && type(of: nodes(at: (touches.first?.location(in: self))!)[0]) != type(of: SKShapeNode()) {
        if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == backBtn {
            let scene = GameScene(size: (view?.bounds.size)!)
            let skView = view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = false
            scene.scaleMode = .resizeFill
            skView.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyFirstBtn {
            //THIS FUNCTION WILL ALLOW USERS TO ALWAYS SELECT FLIPPY
            print(birdInUse)
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "bird1" {
                    //if robobird not selected, select it
                    
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                    /*buySecondBtn = SKSpriteNode(imageNamed: "character-button-unselected")
                    buyThirdBtn = SKSpriteNode(imageNamed: "character-button-unselected")
                    buyFourthBtn = SKSpriteNode(imageNamed: "character-button-unselected")
                    buyFifthBtn = SKSpriteNode(imageNamed: "character-button-unselected")
                    buySixthBtn = SKSpriteNode(imageNamed: "character-button-unselected") */
                    
                }
                else {
                    //if robobird is selected, and clicked, unselect it and go back to default bird.
                    
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buySecondBtn {
            //if not bought
             print(birdInUse)
            if !(characters.contains("ducky")) {
                
                var tokensshop = Int(0)
                /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
                } else {
                    tokensshop = 0
                }*/
                
                tokensshop = GameData.shared().currCoins
                
                if tokensshop < 5 {
                    var alert = UIAlertView(title: "Not Enough Coins", message: "You need 5 coins to buy Flippy's friend", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    //alert asking to buy
                    let alert = UIAlertController(title: "Buy Friend?", message: "Are you sure you want to buy ducky for 5 coins?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        //run your function here
                        print("BOUGHT")
                        tokensshop -= 5
                        
                        //Set GameData.currCoins to value of tokensshop after purchase
                        GameData.shared().currCoins = tokensshop
                        GameData.shared().coinsSpent = GameData.shared().coinsSpent + 5
                        
                        GameData.shared().save()
                        
                        //Adds new purchase to GameData
                        GameData.shared().purchased.add("ducky")
                        GameData.shared().save()
                        
                        print(GameData.shared().purchased)
                        
                        self.characters = GameData.shared().purchased as! [String]
                        
                        //self.characters.append("ducky")
                        //UserDefaults.standard.set(self.characters, forKey: "characters")
                        self.tokenshopLbl.text = "\(GameData.shared().currCoins)"
                        self.buySecondBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //if alert answer == yes  {
                }
            }
            else { //if already bought this will enable it
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "ducky" {
                    //if robobird not selected, select it
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("ducky", forKey: "birdType")
                    buySecondBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "ducky"
                }
                else {
                    //if robobird is selected, and clicked, unselect it and go back to default bird.
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buySecondBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
            }
            // still need to change image

            
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyThirdBtn {
             print(birdInUse)
            //if not bought
            if !(characters.contains("rainbowbird1")) {
                var tokensshop = Int(0)
                /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
                } else {
                    tokensshop = 0
                }*/
                
                tokensshop = GameData.shared().currCoins
                
                if tokensshop < 5 {
                    var alert = UIAlertView(title: "Not Enough Coins", message: "You need 5 coins to buy Flippy's friend", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    //alert asking to buy
                    let alert = UIAlertController(title: "Buy Friend?", message: "Are you sure you want to buy Rainbowbird for 5 coins?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        //run your function here
                        print("BOUGHT")
                        tokensshop -= 5
                        
                        GameData.shared().currCoins = tokensshop
                        GameData.shared().coinsSpent = GameData.shared().coinsSpent + 5
                        GameData.shared().save()
                        
                        //self.characters.append("rainbowbird1")
                        //UserDefaults.standard.set(self.characters, forKey: "characters")
                        
                        //Adds new purchase to GameData
                        GameData.shared().purchased.add("rainbowbird1")
                        GameData.shared().save()
                        
                        self.characters = GameData.shared().purchased as! [String]
                        
                        self.tokenshopLbl.text = "\(GameData.shared().currCoins)"
                        self.buyThirdBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //if alert answer == yes  {
                }
            }
            else { //if already bought this will enable it
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "rainbowbird1" {
                    //if robobird not selected, select it
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("rainbowbird1", forKey: "birdType")
                    buyThirdBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "rainbowbird1"
                }
                else {
                    //if robobird is selected, and clicked, unselect it and go back to default bird.
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buyThirdBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
            }
            // Still need to change image
        

        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyFourthBtn {
             print(birdInUse)
            if !(characters.contains("steveBird1")) {
                
                var tokensshop = Int(0)
                /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
                } else {
                    tokensshop = 0
                }*/
                
                tokensshop = GameData.shared().currCoins
                
                if tokensshop < 5  { //change to 200
                    var alert = UIAlertView(title: "Not Enough Coins", message: "You need 200 coins to buy Flippy's friend", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    //alert asking to buy
                    let alert = UIAlertController(title: "Buy Friend?", message: "Are you sure you want to buy Steve for 5 coins?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        //run your function here
                        print("BOUGHT")
                        tokensshop -= 5
                        //UserDefaults.standard.set(tokensshop, forKey: "currentTokens")
                        
                        GameData.shared().currCoins = tokensshop
                        GameData.shared().coinsSpent = GameData.shared().coinsSpent + 5
                        GameData.shared().save()
                        
                        //self.characters.append("steveBird1")
                        //UserDefaults.standard.set(self.characters, forKey: "characters")
                        
                        //Adds new purchase to GameData
                        GameData.shared().purchased.add("steveBird1")
                        GameData.shared().save()
                        
                        self.characters = GameData.shared().purchased as! [String]
                        
                        self.tokenshopLbl.text = "\(GameData.shared().currCoins)"
                        self.buyFourthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //if alert answer == yes  {
                }
            }
            else { //if already bought this will enable it
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "steveBird1" {
                    //if robobird not selected, select it
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("steveBird1", forKey: "birdType")
                    buyFourthBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "steveBird1"
                }
                else {
                    //if robobird is selected, and clicked, unselect it and go back to default bird.
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buyFourthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
            }
            // still need to change image

        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyFifthBtn {
             print(birdInUse)
            if !(characters.contains("derpyBird1")) {
                var tokensshop = Int(0)
                /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
                } else {
                    tokensshop = 0
                }*/
                
                tokensshop = GameData.shared().currCoins
                
                if tokensshop < 5  { //change to 200
                    var alert = UIAlertView(title: "Not Enough Coins", message: "You need 5 coins to buy Flippy's friend", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    //alert asking to buy
                    let alert = UIAlertController(title: "Buy Friend?", message: "Are you sure you want to buy derpyBird for 5 coins?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        //run your function here
                        print("BOUGHT")
                        tokensshop -= 5
                        GameData.shared().currCoins = tokensshop
                        GameData.shared().coinsSpent = GameData.shared().coinsSpent + 5
                        GameData.shared().save()
                        
                        //Adds new purchase to GameData
                        GameData.shared().purchased.add("derpyBird1")
                        GameData.shared().save()
                        
                        self.characters = GameData.shared().purchased as! [String]
                        
                        //self.characters.append("derpyBird1")
                        //UserDefaults.standard.set(self.characters, forKey: "characters")
                        self.tokenshopLbl.text = "\(GameData.shared().currCoins)"
                        self.buyFifthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //if alert answer == yes  {
 
                }
  
            }
            else { //if already bought this will enable it
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "derpyBird1" {
                    //if robobird not selected, select it
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("derpyBird1", forKey: "birdType")
                    buyFifthBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "derpyBird1"
                }
                else {
                    //if derpyBird1 is selected, and clicked, unselect it and go back to default bird.
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buyFifthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
            }
        }    // still need to change image        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buySixthBtn {
             print(birdInUse)
            if !(characters.contains("fatBird1")) {
                
                var tokensshop = Int(0)
                /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
                    tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
                } else {
                    tokensshop = 0
                }*/
                
                tokensshop = GameData.shared().currCoins
                
                if tokensshop < 5  { //change to 200
                    var alert = UIAlertView(title: "Not Enough Coins", message: "You need 5 coins to buy Flippy's friend", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    //alert asking to buy
                    let alert = UIAlertController(title: "Buy Friend?", message: "Are you sure you want to buy fatBird for 5 coins?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        //run your function here
                        print("BOUGHT")
                        tokensshop -= 5
                        GameData.shared().currCoins = tokensshop
                        GameData.shared().coinsSpent = GameData.shared().coinsSpent + 5
                        GameData.shared().save()
                        
                        //self.characters.append("fatBird1")
                        //UserDefaults.standard.set(self.characters, forKey: "characters")
                        
                        //Adds new purchase to GameData
                        GameData.shared().purchased.add("fatBird1")
                        GameData.shared().save()
                        
                        self.characters = GameData.shared().purchased as! [String]
                        
                        self.tokenshopLbl.text = "\(GameData.shared().currCoins)"
                        self.buySixthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //if alert answer == yes  {
                    
                    
                    
                }
            }
            else { //if already bought this will enable it
                if (UserDefaults.standard.object(forKey: "birdType") as! String) != "fatBird1" {
                    //if robobird not selected, select it
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("fatBird1", forKey: "birdType")
                    buySixthBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "fatBird1"
                }
                else {
                    //if robobird is selected, and clicked, unselect it and go back to default bird.
                    (childNode(withName: birdInUse) as! SKSpriteNode).texture = SKTexture(imageNamed: "character-button-unselected")
                    UserDefaults.standard.set("bird1", forKey: "birdType")
                    buySixthBtn.texture = SKTexture(imageNamed: "character-button-unselected")
                    buyFirstBtn.texture = SKTexture(imageNamed: "character-button-selected")
                    birdInUse = "bird1"
                }
            }
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
    
    
    func createProfileScene() {
       
        /*let hour = Calendar.current.component(.hour, from: Date())
        print("hour \(hour)")

        if hour > 19 || hour < 7 {
            background = SKSpriteNode(imageNamed: "newBG")
        }*/
        //let background = SKSpriteNode(imageNamed: "bg")
        var background = SKSpriteNode(imageNamed: "city")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        //background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        createBackBtn()
        createCoinsAmount()
        createLogo()
        createFirstFriendBtn()
        createSecondFriendBtn()
        createThirdFriendBtn()
        createFourthFriendBtn()
        createFifthFriendBtn()
        createSixthFriendBtn()
    }
    
    func createCoinsAmount() {
        var tokensshop = Int(0)
        /*if UserDefaults.standard.object(forKey: "currentTokens") != nil {
            tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
        } else {
            tokensshop = 0
        }*/
        
        tokensshop = GameData.shared().currCoins
        
        tokenshopLbl.position = CGPoint(x: self.frame.width - (0.121 * self.frame.width) , y: self.frame.height - (0.068 * self.frame.height))
        tokenshopLbl.text = "\(tokensshop)"
        tokenshopLbl.fontColor = UIColor(red: 238/255, green: 221/255, blue: 130/255, alpha: 1)
        tokenshopLbl.zPosition = 5
        tokenshopLbl.fontSize = 20
        tokenshopLbl.fontName = "HelveticaNeue-Bold"
        self.addChild(tokenshopLbl)
    }
    
    func createBackBtn() {
        backBtn = SKSpriteNode(imageNamed: "backbutton")
        backBtn.size = CGSize(width:(0.145 * self.frame.width), height:(0.054 * self.frame.height))
        backBtn.position = CGPoint(x: self.frame.midX / 6, y: self.frame.height - 50)
        backBtn.zPosition = 8
        self.addChild(backBtn)
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "flippysfriends")
        logoImg.size = CGSize(width: (0.657 * self.frame.width), height: (0.204 * self.frame.height))
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.height * 0.9)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.5))
    }
    
    func createFirstFriendBtn() {
        if birdInUse == "bird1" {
            buyFirstBtn = SKSpriteNode(imageNamed: "character-button-selected")
        }
        else {
            buyFirstBtn = SKSpriteNode(imageNamed: "character-button-unselected")
        }
        buyFirstBtn.size = CGSize(width:(0.242 * self.frame.width), height: (0.136 * self.frame.height))
        buyFirstBtn.position = CGPoint(x: self.frame.midX / 2, y: self.frame.height * 0.7)
        buyFirstBtn.zPosition = 8
        buyFirstBtn.name = "bird1"
        self.addChild(buyFirstBtn)
    }
    
    func createSecondFriendBtn() {
        //checks if character is bought //change from stevebird to whatever bird is here
        if characters.contains("ducky") {
            if birdInUse == "ducky" { //if bought and in use
                buySecondBtn = SKSpriteNode(imageNamed: "character-button-selected")
            }
            else { //if bought and not in use
                buySecondBtn = SKSpriteNode(imageNamed: "character-button-unselected")
            }
        }
        else { //if not bought
            buySecondBtn = SKSpriteNode(imageNamed: "character-button-locked2")
        }
        buySecondBtn.size = CGSize(width:(0.242 * self.frame.width), height:(0.136 * self.frame.height))
        buySecondBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.height * 0.7)
        buySecondBtn.zPosition = 8
        buySecondBtn.name = "ducky"
        self.addChild(buySecondBtn)
    }
    
    func createThirdFriendBtn() {
        //checks if character is bought //change from stevebird to whatever bird is here
        if characters.contains("rainbowbird1") {
            if birdInUse == "rainbowbird1" { //if bought and in use
                buyThirdBtn = SKSpriteNode(imageNamed: "character-button-selected")
            }
            else { //if bought and not in use
                buyThirdBtn = SKSpriteNode(imageNamed: "character-button-unselected")
            }
        }
        else { //if not bought
            buyThirdBtn = SKSpriteNode(imageNamed: "character-button-locked3")
        }
        buyThirdBtn.size = CGSize(width:(0.242 * self.frame.width), height:(0.136 * self.frame.height))
        buyThirdBtn.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY)
        buyThirdBtn.zPosition = 8
        buyThirdBtn.name = "rainbowbird1"
        self.addChild(buyThirdBtn)
    }
    //STEVE BIRD IS FOURTH HERE
    func createFourthFriendBtn() {
        //checks if character is bought
        if characters.contains("steveBird1") {
            if birdInUse == "steveBird1" { //if bought and in use
                buyFourthBtn = SKSpriteNode(imageNamed: "character-button-selected")
            }
            else { //if bought and not in use
                buyFourthBtn = SKSpriteNode(imageNamed: "character-button-unselected")
            }
        }
        else { //if not bought
            buyFourthBtn = SKSpriteNode(imageNamed: "character-button-locked4")
        }
        
        buyFourthBtn.size = CGSize(width:(0.242 * self.frame.width), height:(0.136 * self.frame.height))
        buyFourthBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.midY)
        buyFourthBtn.zPosition = 8
        buyFourthBtn.name = "steveBird1"
        self.addChild(buyFourthBtn)
    }
    
    func createFifthFriendBtn() {
        //checks if character is bought
        if characters.contains("derpyBird1") {
            if birdInUse == "derpyBird1" { //if bought and in use
                buyFifthBtn = SKSpriteNode(imageNamed: "character-button-selected")
            }
            else { //if bought and not in use
                buyFifthBtn = SKSpriteNode(imageNamed: "character-button-unselected")
            }
        }
        else { //if not bought
            buyFifthBtn = SKSpriteNode(imageNamed: "character-button-locked5")
        }
        buyFifthBtn.size = CGSize(width:(0.242 * self.frame.width), height:(0.136 * self.frame.height))
        buyFifthBtn.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY / 2)
        buyFifthBtn.zPosition = 8
        buyFifthBtn.name = "derpyBird1"
        self.addChild(buyFifthBtn)
    }

    func createSixthFriendBtn() {
        //checks if character is bought
        if characters.contains("fatBird1") {
            if birdInUse == "fatBird1" { //if bought and in use
                buySixthBtn = SKSpriteNode(imageNamed: "character-button-selected")
            }
            else { //if bought and not in use
                buySixthBtn = SKSpriteNode(imageNamed: "character-button-unselected")
            }
        }
        else { //if not bought
            buySixthBtn = SKSpriteNode(imageNamed: "character-button-locked6")
        }
        buySixthBtn.size = CGSize(width:(0.242 * self.frame.width), height:(0.136 * self.frame.height))
        buySixthBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.midY / 2)
        buySixthBtn.zPosition = 8
        buySixthBtn.name = "fatBird1"
        self.addChild(buySixthBtn)
    }
}












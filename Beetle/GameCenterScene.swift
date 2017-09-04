
import SpriteKit
import Foundation

//NOT USED ANYMORE. DISREGARD
class GameCenterScene: SKScene {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var hscore = Int(0)
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
   
    
    //add stuff to game elements such as createSkinsButton and then implement in createSkinScene.
    
    override func didMove(to view: SKView) {
        print("HERE")
        
        createGCScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("1")
        
        
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
            skView.presentScene(scene, transition: SKTransition.push(with: .up, duration: 1))
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
    
    func createHSLbl() {
        /*if UserDefaults.standard.object(forKey: "highestScore") != nil {
            print("ERROR1")
            hscore = UserDefaults.standard.integer(forKey: "highestScore")
            
        } else {
            UserDefaults.standard.set(0, forKey: "highestScore")
        }*/
        
        //Get highscore from GameData/iCloud
        hscore = GameData.shared().highScore

        highscoreLbl.position = CGPoint(x: self.frame.midX , y: self.frame.height - 100)
        highscoreLbl.text = "High Score: \(hscore)"
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 30
        highscoreLbl.fontColor = UIColor(red: 0/255, green: 255/255, blue: 130/255, alpha: 1)
        highscoreLbl.fontName = "HelveticaNeue-Bold"
        self.addChild(highscoreLbl)
    }

    
    func createGCScene() {
        
        self.view?.window?.rootViewController?.present(GameCenterViewController(), animated: true, completion: nil)
       // showLeaderboard()
        var background = SKSpriteNode(imageNamed: "city")

        // let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        //background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        createBackBtn()
        createHSLbl()
        
        
    }
    
    func createBackBtn() {
        backBtn = SKSpriteNode(imageNamed: "backbutton")
        backBtn.size = CGSize(width:60, height:40)
        backBtn.position = CGPoint(x: self.frame.midX / 6, y: self.frame.height - 50)
        backBtn.zPosition = 8
        self.addChild(backBtn)
    }
}












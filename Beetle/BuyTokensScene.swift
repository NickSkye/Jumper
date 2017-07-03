

import SpriteKit
import Foundation
import StoreKit

class BuyTokensScene: SKScene, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var tokensshop = Int(0)
    let tokenshopLbl = SKLabelNode()
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
    var buyFiveBtn = SKSpriteNode()
    var buyThirtyBtn = SKSpriteNode()
    var buySeventyFiveBtn = SKSpriteNode()
    var buyTwoHundredBtn = SKSpriteNode()
    
    
    //add stuff to game elements such as createSkinsButton and then implement in createSkinScene.
    
    override func didMove(to view: SKView) {
        print("HERE")
        createBuyTokenScene()
        // Set IAPS
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "com.flippysflight.purchasefive", "com.flippysflight.purchasethirty", "com.flippysflight.purchaseseventyfive", "com.flippysflight.purchasetwohundred")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
    }
    
    //In App Purchases
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        var pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //Code here
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        var myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product as! SKProduct)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        print("transactions restored")
        
        var purchasedItemIDS = [AnyObject]()
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.flippysflight.purchasefive":
                print("HERE")
            //Right here is where you should put the function that you want to execute when your in app purchase is complete
            case "com.flippysflight.purchasethirty":
                print("HERE")
            //Right here is where you should put the function that you want to execute when your in app purchase is complete
            case "com.flippysflight.purchaseseventyfive":
                print("HERE")
            //Right here is where you should put the function that you want to execute when your in app purchase is complete
            case "com.flippysflight.purchasetwohundred":
                print("HERE")
            //Right here is where you should put the function that you want to execute when your in app purchase is complete
            default:
                print("IAP not setup")
            }
            
        }
        
        var alert = UIAlertView(title: "Thank You", message: "Your purchase(s) were restored. You may have to restart the app before banner ads are removed.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .purchased, .restored:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.flippysflight.purchasefive":
                    
                    //Here you should put the function you want to execute when the purchase is complete
                    var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                    var totaltokens = Int(currtokens) + 20
                    UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                    tokenshopLbl.text = "\(totaltokens)"
                    
                    var alert = UIAlertView(title: "Thank You", message: "You now have 20 more coins!", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                case "com.flippysflight.purchasethirty":
                    
                    //Here you should put the function you want to execute when the purchase is complete
                    var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                    var totaltokens = Int(currtokens) + 110
                    UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                    tokenshopLbl.text = "\(totaltokens)"
                    
                    var alert = UIAlertView(title: "Thank You", message: "You now have 110 more coins!", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                case "com.flippysflight.purchaseseventyfive":
                    
                    //Here you should put the function you want to execute when the purchase is complete
                    var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                    var totaltokens = Int(currtokens) + 300
                    UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                    tokenshopLbl.text = "\(totaltokens)"
                    
                    var alert = UIAlertView(title: "Thank You", message: "You now have 300 more coins!", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                case "com.flippysflight.purchasetwohundred":
                    
                    //Here you should put the function you want to execute when the purchase is complete
                    var currtokens = UserDefaults.standard.integer(forKey: "currentTokens")
                    var totaltokens = Int(currtokens) + 1000
                    UserDefaults.standard.set("\(totaltokens)", forKey: "currentTokens")
                    tokenshopLbl.text = "\(totaltokens)"
                    
                    var alert = UIAlertView(title: "Thank You", message: "You now have 1000 more coins!", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction)
    {
        print("finish trans")
    }
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
    {
        print("remove trans");
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("1")
        
        
        // Create the method you want to call (see target before)
        
        // put all menu items on scene here as else if using same notation. CTRL-f menu items to find where to remove them on this page
        
        if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == backBtn {
            let scene = GameScene(size: (view?.bounds.size)!)
            let skView = view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = false
            scene.scaleMode = .resizeFill
            skView.presentScene(scene, transition: SKTransition.doorway(withDuration: 1))
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyFiveBtn {
            for product in list {
                var prodID = product.productIdentifier
                if(prodID == "com.flippysflight.purchasefive") {
                    p = product
                    buyProduct()  //This is one of the functions we added earlier
                    break;
                }
            }
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyThirtyBtn {
            for product in list {
                var prodID = product.productIdentifier
                if(prodID == "com.flippysflight.purchasethirty") {
                    p = product
                    buyProduct()  //This is one of the functions we added earlier
                    break;
                }
            }
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buySeventyFiveBtn {
            for product in list {
                var prodID = product.productIdentifier
                if(prodID == "com.flippysflight.purchaseseventyfive") {
                    p = product
                    buyProduct()  //This is one of the functions we added earlier
                    break;
                }
            }
        }
        else if (nodes(at: (touches.first?.location(in: self))!)[0] as? SKSpriteNode)! == buyTwoHundredBtn {
            for product in list {
                var prodID = product.productIdentifier
                if(prodID == "com.flippysflight.purchasetwohundred") {
                    p = product
                    buyProduct()  //This is one of the functions we added earlier
                    break;
                }
            }
        }
        
        //
        
        
        
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
    
    
    func createBuyTokenScene() {
        
        let hour = Calendar.current.component(.hour, from: Date())
        print("hour \(hour)")
        var background = SKSpriteNode(imageNamed: "bg")
        if hour > 19 || hour < 7 {
            background = SKSpriteNode(imageNamed: "newBG")
        }
        //let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        //background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        createBackBtn()
        createBuyFiveBtn()
        createBuyThirtyBtn()
        createBuySeventyFiveBtn()
        createBuyTwoHundredBtn()
        createCoinsAmount()
        
    }
    
    func createBackBtn() {
        backBtn = SKSpriteNode(imageNamed: "backbutton")
        backBtn.size = CGSize(width:60, height:40)
        backBtn.position = CGPoint(x: self.frame.midX / 6, y: self.frame.height - 50)
        backBtn.zPosition = 8
        self.addChild(backBtn)
    }
    
    func createBuyFiveBtn() {
        buyFiveBtn = SKSpriteNode(imageNamed: "play")
        buyFiveBtn.size = CGSize(width:100, height:100)
        buyFiveBtn.position = CGPoint(x: self.frame.midX / 2, y: self.frame.height * 0.75)
        buyFiveBtn.zPosition = 8
        buyFiveBtn.name = "buyFiveButton"
        self.addChild(buyFiveBtn)
    }
    
    func createBuyThirtyBtn() {
        buyThirtyBtn = SKSpriteNode(imageNamed: "play")
        buyThirtyBtn.size = CGSize(width:100, height:100)
        buyThirtyBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.height * 0.75)
        buyThirtyBtn.zPosition = 8
        buyThirtyBtn.name = "buyThirtyButton"
        self.addChild(buyThirtyBtn)
    }
    
    func createBuySeventyFiveBtn() {
        buySeventyFiveBtn = SKSpriteNode(imageNamed: "play")
        buySeventyFiveBtn.size = CGSize(width:100, height:100)
        buySeventyFiveBtn.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY / 2)
        buySeventyFiveBtn.zPosition = 8
        buySeventyFiveBtn.name = "buySeventyFiveButton"
        self.addChild(buySeventyFiveBtn)
    }
    
    func createBuyTwoHundredBtn() {
        buyTwoHundredBtn = SKSpriteNode(imageNamed: "play")
        buyTwoHundredBtn.size = CGSize(width:100, height:100)
        buyTwoHundredBtn.position = CGPoint(x: self.frame.width * 0.75, y: self.frame.midY / 2)
        buyTwoHundredBtn.zPosition = 8
        buyTwoHundredBtn.name = "buyTwoHundredButton"
        self.addChild(buyTwoHundredBtn)
    }
    
    func createCoinsAmount() {
        
        if UserDefaults.standard.object(forKey: "currentTokens") != nil {
            tokensshop = UserDefaults.standard.integer(forKey: "currentTokens")
        } else {
            tokensshop = 0
        }
        
        tokenshopLbl.position = CGPoint(x: self.frame.midX , y: self.frame.height - 50)
        tokenshopLbl.text = "\(tokensshop) Coins"
        tokenshopLbl.zPosition = 5
        tokenshopLbl.fontSize = 40
        tokenshopLbl.fontColor = UIColor(red: 238/255, green: 221/255, blue: 130/255, alpha: 1)
        tokenshopLbl.fontName = "HelveticaNeue-Bold"
        self.addChild(tokenshopLbl)
    }
    
}












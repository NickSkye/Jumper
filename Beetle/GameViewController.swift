
import UIKit
import SpriteKit


class GameViewController: UIViewController, VungleSDKDelegate {

    
   let notificationName = Notification.Name("NotificationIdentifier")
   var sdk = VungleSDK.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            print("ISAVAIL")
        }
        //sdk = VungleSDK.shared()
        sdk?.delegate = self;
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.playVungleAd), name: notificationName, object: nil)
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        
        skView.presentScene(scene, transition: SKTransition.doorway(withDuration: 3))
 
        /*
        button = UIButton(frame: CGRect(x: self.view.frame.width/2 - 50 , y: self.view.frame.height/2 - 100, width: 100, height: 50))
        self.button.isHidden = false
        self.button.isEnabled = true
        button.backgroundColor = .blue
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        shopbutton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 50 , y: self.view.frame.midY , width: 100, height: 50))
        self.shopbutton.isHidden = false
        self.shopbutton.isEnabled = true
        shopbutton.backgroundColor = .blue
        shopbutton.setTitle("SHOP", for: .normal)
        shopbutton.addTarget(self, action: #selector(shopbuttonClicked), for: .touchUpInside)
        
        self.view.addSubview(shopbutton)
        
        
        
        self.bgImage.isHidden = false
 
 */
    }



    func playVungleAd() {
        do {
            
        
        try sdk?.playAd(self, withOptions: nil)
        
            
        } catch {
            print("ERROR")
            Variables.adAboutToPlay = false
            var alert = UIAlertView(title: "Uh Oh!", message: "Ads currently unavailable. Please try again later.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
    }
    
    func vungleSDKWillCloseAd(withViewInfo viewInfo: [AnyHashable : Any]!) {
       print(viewInfo)
        print(("\(viewInfo["didDownload"]!)").contains("1"))
        print(Variables.lasttokens) // change this to determine whether tokens were got
        if ("\(viewInfo["completedView"]!)").contains("1") {
        if Variables.lasttokens > 0 {
            var doubledlastgamestokens = Variables.lasttokens * 2
            GameData.shared().currCoins = GameData.shared().currCoins + doubledlastgamestokens
            GameData.shared().save()
            // icloud total tokens += doubledlastgamestokens
            print("double last game")
        }
        else if Variables.lasttokens == 0{
            GameData.shared().currCoins = GameData.shared().currCoins + 2
            GameData.shared().save()
            print("plus two tokens")
            //BuyTokensScene().updateLabel(coinNum: GameData.shared().currCoins)
        }
        }
        
        if ("\(viewInfo["didDownload"]!)").contains("1") {
            GameData.shared().currCoins = GameData.shared().currCoins + 3
            GameData.shared().save()
            print("plus three tokens")
        }
        Variables.adAboutToPlay = false
        
    }
    func vungleSDKwillShowAd() {
        print("__________vungleSDKwillShowAd")
        
    }
    func vungleSDKAdPlayableChanged(isAdPlayable:Bool) {
        print("__________vungleSDKAdPlayableChanged")
        
    }
    
    /*
    func vungleSDKwillCloseAd(withViewInfo viewInfo: [AnyHashable : Any]!, willPresentProductSheet: Bool){
        print(viewInfo)
    }
    */
      override var shouldAutorotate: Bool {
        return false
    }
  /*
    @IBAction func skinButtPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "mainToSkins", sender: self)
    }
    */

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

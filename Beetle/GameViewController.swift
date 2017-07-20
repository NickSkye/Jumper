
import UIKit
import SpriteKit


class GameViewController: UIViewController, VungleSDKDelegate {

    
   let notificationName = Notification.Name("NotificationIdentifier")
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
        var sdk = VungleSDK.shared()
        try sdk?.playAd(self, withOptions: nil)
            
            
        } catch {
            print("ERROR")
        }
        
        
    }
    
    func vungleSDKwillCloseAdWithViewInfo(viewInfo: [NSObject : AnyObject]!, willPresentProductSheet: Bool) {
        
        print("vungleSDKwillCloseAdWithViewInfo")
        
    }
    
    func vungleSDKwillShowAd() {
        
        print("vungleSDKwillShowAd")
        
    }
    
    func vungleSDKAdPlayableChanged(isAdPlayable:Bool) {
        
        print("vungleSDKAdPlayableChanged")
        
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

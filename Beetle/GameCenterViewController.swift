
import UIKit
import SpriteKit
import GameKit

class GameCenterViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.highestscores"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "city")!)
        assignbackground()
        print("GOT HERE")
        // Call the GC authentication controller
        
        Variables.loaderView.center = (self.view?.center)!
        
        self.view?.addSubview(Variables.loaderView)
        authenticateLocalPlayer()
        //checkGCLeaderboard()
       // getScore()
        addScoreAndSubmitToGC()
        
        self.checkGCLeaderboard()
        
        
        
           }
    
    func goBack() {
        //self.performSegue(withIdentifier: "toMain", sender: self)
        
        self.dismiss(animated: false , completion: nil)
        Variables.loaderView.removeFromSuperview()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let button = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
            button.backgroundColor = .blue
            
            button.setTitle("Back", for: .normal)
            button.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
            self.view.addSubview(button)
        })
        
    }
    /*d
    func getScore() {
        if (GKLocalPlayer.localPlayer().isAuthenticated) {
            GKLeaderboard.loadLeaderboards { objects, error in
                if let e = error {
                    print(e)
                } else {
                    if let leaderboards = objects {
                        for leaderboard in leaderboards {
                            if let localPlayerScore = leaderboard.localPlayerScore {
                                print(localPlayerScore)
                            }
                        }
                    }
                }
            }
        }

    }
    
    */
    func assignbackground(){
        
        let background = UIImage(named: "city")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
 
        
       
 
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                self.checkGCLeaderboard()
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    // MARK: - ADD 10 POINTS TO THE SCORE AND SUBMIT THE UPDATED SCORE TO GAME CENTER
    func addScoreAndSubmitToGC() {
        // Add 10 points to current score
        /*
        if UserDefaults.standard.object(forKey: "highestScore") != nil {
            
            score = UserDefaults.standard.integer(forKey: "highestScore")
            
        } else {
            UserDefaults.standard.set(0, forKey: "highestScore")
        }
        */
        
        var hscore = GameData.shared().highScore
    
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(hscore)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        goBack()
        
    }
    
    // MARK: - OPEN GAME CENTER LEADERBOARD
     func checkGCLeaderboard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .default
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    
    
    override var shouldAutorotate: Bool {
        return false
    }
        
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

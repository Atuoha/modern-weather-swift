
import UIKit

class SplashViewController: UIViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    @IBAction func GetStarted(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToSearch"{
            let searchVC = segue.destination as! SearchViewController
            
            searchVC.modalPresentationStyle = .fullScreen
        }
    }
}

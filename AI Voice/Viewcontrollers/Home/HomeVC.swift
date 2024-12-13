import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var viewChatIcon: UIView!
    @IBOutlet weak var viewMicIcon: UIView!
    @IBOutlet weak var viewTransletIcon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewChatIcon.clipsToBounds = true
        self.viewChatIcon.cornerRadius = 22
        self.viewChatIcon.borderColor = .gray
        self.viewChatIcon.borderWidth = 1
        self.viewChatIcon.layer.masksToBounds = true
        
        self.viewMicIcon.clipsToBounds = true
        self.viewMicIcon.cornerRadius = 22
        self.viewMicIcon.borderColor = .gray
        self.viewMicIcon.borderWidth = 1
        self.viewMicIcon.layer.masksToBounds = true
        
        self.viewTransletIcon.clipsToBounds = true
        self.viewTransletIcon.cornerRadius = 22
        self.viewTransletIcon.borderColor = .gray
        self.viewTransletIcon.borderWidth = 1
        self.viewTransletIcon.layer.masksToBounds = true
    }

    @IBAction func onTappedAiVoiceChanger(_ sender: UIButton) {
        Navigation.shared.gotoSelectVoiceChangerVC(vc: self)
    }
}

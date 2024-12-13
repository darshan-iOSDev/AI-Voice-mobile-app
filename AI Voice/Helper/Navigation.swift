import Foundation
import UIKit

struct Navigation {
    static var shared = Navigation()
    
    func gotoBack(from vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }

    func gotoRoot(vc: UIViewController) {
        vc.navigationController?.popToRootViewController(animated: true)
    }

    func gotoAppleLoginVC(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AppleLoginVC") as! AppleLoginVC
        vc.navigationController?.pushViewController(VC, animated: true)
    }
    
    func gotoTabVC(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        vc.navigationController?.pushViewController(VC, animated: true)
    }
    
    func gotoSelectVoiceChangerVC(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectVoiceChangerVC") as! SelectVoiceChangerVC
        vc.navigationController?.pushViewController(VC, animated: true)
    }
    
    func gotoAiVoiceChangerVC(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AiVoiceChanger") as! AiVoiceChanger
        vc.navigationController?.pushViewController(VC, animated: true)
    }
}

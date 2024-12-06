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
}

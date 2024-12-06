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

}

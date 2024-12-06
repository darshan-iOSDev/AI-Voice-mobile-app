import Foundation
import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?
var soundPlayer: AVAudioPlayer?


func showAlertMsg(Message: String, AutoHide:Bool) -> Void {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: "", message: Message, preferredStyle: UIAlertController.Style.alert)
        if AutoHide == true {
            let deadlineTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                alert.dismiss(animated: true, completion:nil)
            }
        }
        else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
    }
}

func isValidateEmail(email:String) -> Bool {
    let emailRegx = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]{1}|[\\w-]{2,}))@"
    + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
    + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
    + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
    + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|"
    + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegx)
    let result = emailTest.evaluate(with: email)
    return result
}

func isValidatePassword(password: String) -> Bool{
    let regularExpression = "^.{8,}$"
    let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
    return passwordValidation.evaluate(with: password)
}

func generateThreeDigitRandomNumber() -> String {
    let randomNumber = Int.random(in: 100...999)
    return String(randomNumber)
}


@IBDesignable
class CornerView: UIView {
    
    @IBInspectable var leftTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    
    @IBInspectable var leftBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyMask()
    }
    func applyMask()
    {
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.pathForCornersRounded(rect:self.bounds).cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
    func pathForCornersRounded(rect:CGRect) ->UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0 + leftTopRadius , y: 0))
        path.addLine(to: CGPoint(x: rect.size.width - rightTopRadius , y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.size.width , y: rightTopRadius), controlPoint: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width , y: rect.size.height - rightBottomRadius))
        path.addQuadCurve(to: CGPoint(x: rect.size.width - rightBottomRadius , y: rect.size.height), controlPoint: CGPoint(x: rect.size.width, y: rect.size.height))
        path.addLine(to: CGPoint(x: leftBottomRadius , y: rect.size.height))
        path.addQuadCurve(to: CGPoint(x: 0 , y: rect.size.height - leftBottomRadius), controlPoint: CGPoint(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0 , y: leftTopRadius))
        path.addQuadCurve(to: CGPoint(x: 0 + leftTopRadius , y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        return path
    }
}

func setView(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
    })
}

func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil, ipad: (forIpad: Bool, view: UIView?) = (false, nil)) -> UIActivityViewController {
    let activityViewController = UIActivityViewController(activityItems: items,applicationActivities: nil)
    if ipad.forIpad {
        activityViewController.popoverPresentationController?.sourceView = ipad.view
    }
    if let excludedActivityTypes = excludedActivityTypes {
        activityViewController.excludedActivityTypes = excludedActivityTypes
    }
    return activityViewController
}

func clearUserDefaults() {
    let appDomain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: appDomain)
    
}

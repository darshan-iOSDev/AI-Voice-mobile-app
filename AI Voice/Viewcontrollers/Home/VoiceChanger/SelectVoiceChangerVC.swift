import UIKit

class SelectVoiceChangerVC: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewUploadFile: UIView!
    @IBOutlet weak var viewRecordView: UIView!
    
    var isSelectUploadFile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnContinue.isHidden = true
        
        self.viewRecordView.cornerRadius = 16
        self.viewRecordView.clipsToBounds = true
        self.viewRecordView.layer.masksToBounds = true
        self.viewRecordView.borderWidth = 1
        self.viewUploadFile.borderWidth = 1
        self.viewUploadFile.cornerRadius = 16
        self.viewUploadFile.borderColor = .clear
        self.viewRecordView.borderColor = .clear
        self.viewUploadFile.clipsToBounds = true
        self.viewUploadFile.layer.masksToBounds = true
    }

    @IBAction func onTappedRecordVoice(_ sender: Any) {
        isSelectUploadFile = false
        self.btnContinue.isHidden = false
        self.viewRecordView.borderColor = .white
        self.viewUploadFile.borderColor = .clear
    }
    
    @IBAction func onTappedUploadFile(_ sender: Any) {
        isSelectUploadFile = true
        self.btnContinue.isHidden = false
        self.viewUploadFile.borderColor = .white
        self.viewRecordView.borderColor = .clear
    }
    
    @IBAction func btnTapBack(_ sender: Any) {
        Navigation.shared.gotoBack(from: self)
    }
    
    @IBAction func onTappedContinue(_ sender: Any) {
        if isSelectUploadFile {
            Navigation.shared.gotoAiVoiceChangerVC(vc: self)
        } else {
            print("Record")
        }
        
    }
}

import UIKit
import Foundation

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var placeholderFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        guard let placeholderText = placeholder else { return }
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.font: placeholderFont
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

class ImagePreviewViewController: UIViewController {
    
    var image: UIImage?
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.image = image
        view.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPreview))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissPreview() {
        self.dismiss(animated: true, completion: nil)
    }
}

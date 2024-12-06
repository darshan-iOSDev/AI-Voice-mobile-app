import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of the tab bar item title
        let selectedColor = UIColor.white  // Set your desired color
        let unselectedColor = UIColor.darkGray  // Set your desired color

        // Ensure the font is loaded
        guard let customFont = UIFont(name: "AvenirNext-Medium", size: 12) else {
            print("Failed to load Avenir Next font.")
            return
        }

        // Set custom font attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: unselectedColor,
            .font: customFont
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedColor,
            .font: customFont
        ]

        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

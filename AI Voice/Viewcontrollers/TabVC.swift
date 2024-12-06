//
//  TabVC.swift
//  AI Voice
//
//  Created by Chiku on 06/12/24.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of the tab bar item title
        let selectedColor = UIColor.white  // Set your desired color
        let unselectedColor = UIColor.darkGray  // Set your desired color
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedColor], for: .selected)
    }
}

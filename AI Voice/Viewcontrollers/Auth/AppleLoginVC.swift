import UIKit
import AuthenticationServices

class AppleLoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedContinueWithApple(_ sender: UIButton) {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
        Navigation.shared.gotoTabVC(vc: self)
    }
}

extension AppleLoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Extract user information
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            // Print out user data
            print(">>>>>>>>>> Apple User Login Successful")
            print(">>>>>>>>>> User Identifier: \(userIdentifier)")
            print(">>>>>>>>>> Full Name: \(fullName?.givenName ?? "N/A") \(fullName?.familyName ?? "N/A")")
            print(">>>>>>>>>> Email: \(email ?? "N/A")")
            
            // Handle successful login (e.g., save to keychain, send to backend)
            let userInfo = [
                "userIdentifier": userIdentifier,
                "firstName": fullName?.givenName ?? "",
                "lastName": fullName?.familyName ?? "",
                "email": email ?? ""
            ]
            
            saveUserCredentials(userInfo: userInfo)
            UserDefaultManager.setStringToUserDefaults(value: userIdentifier, key: Constant.UD.USER_ID)
            
            // Safely unwrap fullName and email before saving them
            if let givenName = fullName?.givenName {
                UserDefaultManager.setStringToUserDefaults(value: givenName, key: Constant.UD.USER_FULLNAME)
            } else {
                // Handle missing full name if necessary
                UserDefaultManager.setStringToUserDefaults(value: "", key: Constant.UD.USER_FULLNAME)
            }
            
            if let familyName = fullName?.familyName {
                UserDefaultManager.setStringToUserDefaults(value: familyName, key: Constant.UD.USER_LASTNAME)
            } else {
                // Handle missing family name if necessary
                UserDefaultManager.setStringToUserDefaults(value: "", key: Constant.UD.USER_LASTNAME)
            }
            
            if let email = email {
                UserDefaultManager.setStringToUserDefaults(value: email, key: Constant.UD.USER_EMAIL)
            } else {
                // Handle missing email if necessary
                UserDefaultManager.setStringToUserDefaults(value: "", key: Constant.UD.USER_EMAIL)
            }
            
            UserDefaultManager.setBooleanToUserDefaults(value: true, key: Constant.UD.USER_LOGED_IN)
            navigateToMainApp()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print(">>>>>>>>> Apple Sign In Failed: \(error.localizedDescription)")
        showLoginErrorAlert()
    }
}




// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Additional Helper Methods
extension AppleLoginVC {
    private func saveUserCredentials(userInfo: [String: String]) {
        // Save user credentials securely (e.g., using Keychain)
        // Implementation depends on your specific keychain wrapper
        // Example using KeychainSwift or similar library
        // KeychainSwift().set(userInfo["userIdentifier"] ?? "", forKey: "appleUserID")
    }
    
    private func navigateToMainApp() {
        // Perform segue or present main app view controller
        // Example:
        // let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        // navigationController?.pushViewController(mainVC, animated: true)
        Navigation.shared.gotoTabVC(vc: self)
    }
    
    private func showLoginErrorAlert() {
        let alert = UIAlertController(
            title: "Login Failed",
            message: "Unable to complete Apple Sign In. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

import UIKit
import AuthenticationServices

class AppleLoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedContinueWithApple(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleLoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Extract user information
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Print out user data
            print("Apple User Login Successful")
            print("User Identifier: \(userIdentifier)")
            print("Full Name: \(fullName?.givenName ?? "N/A") \(fullName?.familyName ?? "N/A")")
            print("Email: \(email ?? "N/A")")
            
            // Optional: Create a user object or send to your backend
            let userInfo = [
                "userIdentifier": userIdentifier,
                "firstName": fullName?.givenName ?? "",
                "lastName": fullName?.familyName ?? "",
                "email": email ?? ""
            ]
            
            // Handle successful login (e.g., save to keychain, send to backend)
            saveUserCredentials(userInfo: userInfo)
            navigateToMainApp()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print("Apple Sign In Failed: \(error.localizedDescription)")
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

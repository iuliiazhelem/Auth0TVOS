//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Auth0

class ViewController: UIViewController {

    var retrievedCredentials: Credentials?

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //Step 1: Login to Auth0
    @IBAction func clickLoginButton(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("Please eneter an email");
            return;
        }
        if (self.passwordTextField.text?.characters.count < 1) {
            self.showMessage("Please eneter a password");
            return;
        }

        Auth0
        .authentication()
        .login(
            usernameOrEmail: emailTextField.text!,
            password: passwordTextField.text!,
            connection: "Username-Password-Authentication"
        )
        .start { result in
            switch result {
            case .Success(let credentials):
                self.retrievedCredentials = credentials
                self.fetchUserInfoWithToken(credentials.idToken)
                print("access_token: \(credentials.accessToken)")
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    //Step 2: Fetch the User info
    func fetchUserInfoWithToken(token:String?) {
        if let actualToken = token {
            Auth0
            .authentication()
            .tokenInfo(token: actualToken)
            .start { result in
                switch result {
                case .Success(let profile):
                    self.showUserProfile(profile)
                case .Failure(let error):
                    self.showMessage("Error : \(error)")
                }
            }
        }
    }

    //Step 3: Get Facebook data with Facebook AccessToken
    @IBAction func clickFacebookButton(sender: AnyObject) {
        //Facebook user access token from Access Token Tool https://developers.facebook.com 
        let fbAccessToken = "EAAOwPUTw7gIBAJvFDCOWg5STnpWbdKhfTOZC256pyQyUqJjDaSLdeU6ECgXdiLN8h49vMaNxHTw6PIdnIYaYQJMuYr5bzlZCP2qPn5pL6D8pDOIptwjvtHA9iwtCRgCjX0moMPDYAbm6J9cwVZCZCQNvWA2p0F8ZD"
        Auth0
            .authentication()
            .loginSocial(token: fbAccessToken, connection: "facebook")
            .start { result in
                switch result {
                case .Success(let credentials):
                    self.retrievedCredentials = credentials
                    self.fetchUserInfoWithAccessToken(credentials.accessToken)
                    print("access_token: \(credentials.accessToken)")
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    //Step 4: Fetch the User info
    func fetchUserInfoWithAccessToken(token:String?) {
        if let actualToken = token {
            Auth0
                .authentication()
                .userInfo(token: actualToken)
                .start { result in
                    switch result {
                    case .Success(let profile):
                        self.showUserProfile(profile)
                    case .Failure(let error):
                        self.showMessage("Error : \(error)")
                    }
            }
        }
    }

    //Internal methods
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showUserProfile(profile: Profile) {
        dispatch_async(dispatch_get_main_queue()) {
            self.usernameLabel.text = profile.name
            self.emailLabel.text = profile.email
        }
    }
}


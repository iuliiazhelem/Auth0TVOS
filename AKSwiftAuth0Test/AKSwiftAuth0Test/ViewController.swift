//
//  ViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 13.09.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit
import Auth0

class ViewController: UIViewController {

    var retrievedCredentials: Credentials?

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func clickLoginButton(sender: AnyObject) {
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


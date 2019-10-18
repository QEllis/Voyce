//
//  LoginViewController.swift
//  Voyce
//
//  Created by Student on 10/5/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

private let userManager = UserManager.shared

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        loginButton.isEnabled = false
        
        //FirebaseApp.configure()
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self as? FUIAuthDelegate
        //authUI?.FacebookAutoLogAppEventsEnabled = false;
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
//            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()),
            ]
        authUI?.providers = providers
        
        let authViewController = authUI?.authViewController()
        
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func UsernameTextFieldEditingChanged(_ sender: Any) {
        CheckFields()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: Any) {
        CheckFields()
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func LoginButtonDidPressed(_ sender: Any) {
        if(userManager.username == usernameTextField.text && userManager.password == passwordTextField.text){
            print("Logged in")
            
            let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedVC")
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            print("Login Failed")
        }
        
    }

    func CheckFields(){
        if(!usernameTextField.text!.isEmpty
            && !passwordTextField.text!.isEmpty){
            loginButton.isEnabled = true
        }
        else{
            loginButton.isEnabled = false
        }
    }
    
}

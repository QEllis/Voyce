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

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
//        loginButton.isEnabled = false
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        //authUI?.FacebookAutoLogAppEventsEnabled = false;
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
//            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()),
            ]
        authUI?.providers = providers
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
      }

      private func isUserSignedIn() -> Bool {
        guard Auth.auth().currentUser != nil else { return false }
        return true
      }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
      // handle user and error as necessary

        //User init
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            print("User Logged in: "+user!.uid);
            userManager.userLogin(u: user!)
        } else {
            print("No current user");
        }
        
        let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedVC")
                   self.navigationController?.pushViewController(vc, animated: true)
        
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
//        CheckFields()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: Any) {
//        CheckFields()
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func ShowLoginView(_ sender: Any) {
        
//        let authViewController = authUI?.authViewController()
//        self.present(authViewController!, animated: true, completion: {
//            let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedVC")
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
        
        if let authVC = authUI?.authViewController() {
          present(authVC, animated: true, completion: nil)
        }
        
    }
}

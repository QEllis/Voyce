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

private let userManager = DatabaseManager.shared

class LoginViewController: UIViewController, FUIAuthDelegate
{
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let currentUser = Auth.auth().currentUser
    override func viewDidLoad()
    {
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        //authUI?.FacebookAutoLogAppEventsEnabled = false;
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    private func isUserSignedIn() -> Bool
    {
        guard Auth.auth().currentUser != nil else
        {
            return false
        }
        return true
      }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?)
    {
        if Auth.auth().currentUser != nil
        {
            let user = Auth.auth().currentUser
            userManager.userLogin(u: user!)
            
            /// Loads user table for FindPeopleViewController Page.
            DatabaseManager.shared.loadOtherUsers()
            
            let vc = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "VoyceTabBarVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false
        {
            return true
        }
        return false
    }
    
    @IBAction func ShowLoginView(_ sender: Any)
    {
        if let authVC = authUI?.authViewController()
        {
            present(authVC, animated: true, completion: nil)
        }
    }
}

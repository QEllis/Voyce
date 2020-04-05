//
//  StartUpViewController.swift
//  Voyce
//
//  Created by Tyler Luk on 4/3/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

private let userManager = DatabaseManager.shared
class StartUpViewController: UIViewController, FUIAuthDelegate{
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let currentUser=Auth.auth().currentUser
        override func viewDidLoad()
        {
            //if user is signed in, navigate them to view controller
            if isUserSignedIn()
            {
               loadData()
               navigateToFeed()
            }
            else
            {
                navigateToLogin()
            }
            // You need to adopt a FUIAuthDelegate protocol to receive callback
            authUI?.delegate = self
            //authUI?.FacebookAutoLogAppEventsEnabled = false;
            let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
            authUI?.providers = providers
        }
    
    //loads user data
    public func loadData()
    {
        let user = Auth.auth().currentUser
        print("User Logged in: "+user!.uid);
        userManager.userLogin(u: user!)
        // Loads user table for FindPeopleViewController Page
        DatabaseManager.shared.loadOtherUsers()
    }
    
    //navigate user to feed if user is signed in
      public func navigateToFeed()
      {
          let vc = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "VoyceTabBarVC")
          self.navigationController?.pushViewController(vc, animated: true)
      }
      
      public func navigateToLogin()
      {
             let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login")
             self.navigationController?.pushViewController(vc, animated: true)
         }
    
    private func isUserSignedIn() -> Bool
       {
           guard Auth.auth().currentUser != nil else
           {
               return false
           }
           return true
         }
}

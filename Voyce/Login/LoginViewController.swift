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

class LoginViewController: UIViewController, FUIAuthDelegate {
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let currentUser = Auth.auth().currentUser
    
    @IBOutlet var signInButton: UIButton!

    override func viewDidLoad()
    {
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        //authUI?.FacebookAutoLogAppEventsEnabled = false;
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
        signInButton.layer.borderWidth = 1
        signInButton.layer.cornerRadius = 15
        signInButton.layer.borderColor = UIColor(named: "Text - Body")?.cgColor
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
            self.loadData()
        }
    }
    
    /// Loads user data.
    public func loadData()
    {
        let user = Auth.auth().currentUser

        userManager.sharedUser = User.init(user: user!)
        let collection = userManager.db.collection("users")
        let userDoc = collection.document(user!.uid)
        userDoc.getDocument { (document, error) in
            if let document = document, document.exists
            {
                userManager.sharedUser.loadUserData(document: document)
                DatabaseManager.shared.loadOtherUsers()
                let vc = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "VoyceTabBarVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                userDoc.setData(userManager.sharedUser.dictionary)
                print("User does not exist yet. New user added to database.", user!.uid)
                self.loadData()
            }
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

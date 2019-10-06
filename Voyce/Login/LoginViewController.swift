//
//  LoginViewController.swift
//  Voyce
//
//  Created by Student on 10/5/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

private let userManager = UserManager.shared

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        loginButton.isEnabled = false
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

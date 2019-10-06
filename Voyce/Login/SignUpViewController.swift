//
//  SignUpViewController.swift
//  Voyce
//
//  Created by Student on 10/5/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

private let userManager = UserManager.shared

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        signUpButton.isEnabled = false

    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func UsernameTextFieldEditingDidChanged(_ sender: Any) {
        CheckFields()
    }
    
    @IBAction func EmailTextFieldEditingChanged(_ sender: Any) {
        CheckFields()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: Any) {
        CheckFields()
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
//      Add username and password to the user manager and then segue to feed
        userManager.username = usernameTextField.text!
        userManager.email = emailTextField.text!
        userManager.password = passwordTextField.text!
//        print("Sing Up Pressed")
        
        guard let feedVC = UIStoryboard(name: "Feed", bundle: nil)
              .instantiateInitialViewController() as? FeedViewController else { return }
            navigationController?.pushViewController(feedVC, animated: true)
    }
    
    @IBAction func backToLoginPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func CheckFields(){
        if(!usernameTextField.text!.isEmpty
            && !passwordTextField.text!.isEmpty
            && !emailTextField.text!.isEmpty){
            signUpButton.isEnabled = true
        }
        else{
            signUpButton.isEnabled = false
        }
    }
    
}

//
//  MyProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

private let user = UserManager.sharedUser

class MyProfileViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var goodVibesLabel: UILabel!
  @IBOutlet weak var followButtonLabel: UIButton!
  
  var followed:Bool = false
  
  override func viewDidLoad() {
    print("Inside view did load")
    //TODO: take user information from token passed through segue
    usernameLabel.text = "@" + user.username
  }
  
  @IBAction func backPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func transferButtonPressed(_ sender: Any) {
    //put bank account function here
  }
}


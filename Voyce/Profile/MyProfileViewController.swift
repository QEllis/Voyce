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
  
  var followed:Bool = false
  
  override func viewDidLoad() {
    nameLabel.text = user.name
    usernameLabel.text = "@" + user.username
    goodVibesLabel.text = "Good Vibes: \(user.goodVibes)"
  }
  
  @IBAction func backPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func transferButtonPressed(_ sender: Any) {
    //put bank account function here
  }
}


//
//  ProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

private let userManager = UserManager.shared

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goodVibesLabel: UILabel!
    
    override func viewDidLoad() {
        usernameLabel.text = "@" + userManager.username
    }
    @IBAction func transferToBankPressed(_ sender: Any) {
//        add functionality for transferring Good Vibes to bank
    }
}

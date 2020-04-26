//
//  FindPeopleProfileViewController.swift
//  Voyce
//
//  Created by Hekmat on 4/13/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import UIKit

class FindPeopleProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var totalVibesLabel: UILabel!
    
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Load the info of the user.
        profileImage.image = URLToImg(URL(string: user!.profilePic))
        profileImage.layer.cornerRadius = (profileImage?.frame.height ?? 40.0)/2.0
        nameLabel.text = user?.name
        usernameLabel.text = "@\(user!.username)"
        self.navigationItem.title = user?.name
        totalVibesLabel.text = "Total Vibes: \(user!.totalVibes)"
    }
    
    func URLToImg(_ url: URL?) -> UIImage? {
        guard let imageURL = url else{
            return nil
        }
        let data = try? Data(contentsOf: imageURL)
        return UIImage(data: data!)
    }
}

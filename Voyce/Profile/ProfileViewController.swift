//
//  ProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

//private let user = UserManager.shared.sharedUser

class ProfileViewController: UIViewController
{
    // Member Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goodVibesLabel: UILabel!
    @IBOutlet weak var followButtonLabel: UIButton!
    var isFollowed:Bool = false
    var user = User.init()
    
    // Member Functions
    override func viewDidLoad()
    {
        //TODO: take user information from token passed through segue
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
        goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
        setIsFollowed()
    }
    
    // Checks if the user is followed or not and sets isFollowed bool value
    func setIsFollowed()
    {
        if(user.checkIfFollowed(userID: usernameLabel.text!))
        {
            followButtonLabel.setTitle("Unfollow", for: .normal)
            isFollowed = true
        }
        else
        {
            followButtonLabel.setTitle("Follow", for: .normal)
        }
    }
    
    func switchFollowButton()
    {
        isFollowed.toggle()
        if(isFollowed)
        {
            followButtonLabel.setTitle("Unfollow", for: .normal)
        }
        else
        {
            followButtonLabel.setTitle("Follow", for: .normal)
        }
    }
    
    // Allows user to follow/unfollower other user and updates database accordingly
    @IBAction func FollowPressed(_ sender: Any)
    {
        if(isFollowed)
        {
            user.removeFollowed(userID: usernameLabel.text!)
        }

        else
        {
            user.addFollowed(userID: usernameLabel.text!)
        }
        switchFollowButton()
    }
    
    //
    @IBAction func backPressed(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}

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

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var goodVibesLabel: UILabel!
  @IBOutlet weak var followButtonLabel: UIButton!
  
  var followed:Bool = false

  var user = User.init()
  override func viewDidLoad() {
    //TODO: take user information from token passed through segue
    nameLabel.text = user.name
    usernameLabel.text = "@" + user.username
    goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
    
    //check if user is already followed
    if(user.checkIfFollowed(userID: usernameLabel.text!)){
      //if already followed, turn button text to followed
      followButtonLabel.setTitle("Unfollow", for: .normal)
      followed = true
//      print("User followed")
    }else{
      //else set to follow
      followButtonLabel.setTitle("Follow", for: .normal)
//      print("User not followed")
    }
  }
  @IBAction func FollowPressed(_ sender: Any) {
    if(followed){
      //Unfollow user
        user.removeFollowed(userID: usernameLabel.text!)
    }else{
      //follow user
        user.addFollowed(userID: usernameLabel.text!)
    }
    switchFollowButton()
    
  }
  @IBAction func backPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  func switchFollowButton(){
    followed.toggle()
    if(followed){
      followButtonLabel.setTitle("Unfollow", for: .normal)
    }else{
      //else set to follow
      followButtonLabel.setTitle("Follow", for: .normal)
    }
  }
}

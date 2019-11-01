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

class MyProfileViewController: UIViewController, UITableViewDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var goodVibesLabel: UILabel!
  
  var followed:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UserManager.shared.initWithPlaceholderPosts()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MyPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPostCell")
    NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
    
    nameLabel.text = user.name
    usernameLabel.text = "@" + user.username
    goodVibesLabel.text = "Good Vibes: \(user.goodVibes)"
  }
  
  @objc private func newPosts() {
    tableView.reloadData()
  }
  
  @IBAction func backPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func transferButtonPressed(_ sender: Any) {
    //put bank account function here
  }
}

//this lets you create a comment, we don't need this

//extension MyProfileViewController: UITableViewDelegate {
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    //replace this with post viewer
//    guard let vc = UIStoryboard(name: "MyPostCreation", bundle: nil).instantiateViewController(withIdentifier: "CommentCreationVC") as? CommentCreationViewController else { return }
//    vc.post = UserManager.shared.posts[indexPath.row]
//    navigationController?.pushViewController(vc, animated: true)
//  }
//
//}

extension MyProfileViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return count of my posts
    return UserManager.shared.myPosts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostTableViewCell
    cell.fillOut(with: UserManager.shared.myPosts[indexPath.row])
//    cell.delegate = self
    return cell
  }
  
}

//this sends you to the profile page of post creator, also don't need this
//
//extension MyProfileViewController: PostTableViewCellDelegate {
//  func profileButtonDidPressed(postUser: User) {
//    let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
//    vc.user = postUser
//    navigationController?.pushViewController(vc,animated:true)
//  }
//}

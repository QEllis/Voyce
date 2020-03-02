//
//  MyProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let user = UserManager.shared.sharedUser

class MyProfileViewController: UIViewController, UITableViewDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var goodVibesLabel: UILabel!
  var followed:Bool = false
//  lazy var functions = Functions.functions()
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    UserManager.shared.initWithPlaceholderPosts()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MyPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPostCell")
    NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
    
    nameLabel.text = user.name
    usernameLabel.text = "@" + user.username
    goodVibesLabel.text = "Good Vibes: \(user.goodVibes)"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    loadTextFields()
    tableView.reloadData()
  }
  
  private func loadTextFields(){
    print("Loaded Text Fields")
    print("\(UserManager.shared.sharedUser.goodVibes)")
    nameLabel.text = user.name
    usernameLabel.text = "@" + user.username
    goodVibesLabel.text = "Good Vibes: \(user.goodVibes)"
  }
  
  @objc private func newPosts() {
    print("New opsts reload")
    tableView.reloadData()
  }
  
  @IBAction func transferButtonPressed(_ sender: Any)
  {
    print("Button Pressed")
//    functions.httpsCallable("addMessage").call(["text": "This is a test"])
//    {
//        (result, error) in
//        // Handles any errors in the communication
//        if let error = error as NSError?
//        {
//            if error.domain == FunctionsErrorDomain
//            {
//                let code = FunctionsErrorCode(rawValue: error.code)
//                let message = error.localizedDescription
//                let details = error.userInfo[FunctionsErrorDetailsKey]
//            }
//        }
//        // Handles the responses from the server
//        if let text = (result?.data as? [String: Any])?["text"] as? String
//        {
//            print("This is the output " + text)
//        }
//    }
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
    cell.delegate = self
    return cell
  }
  
}

extension MyProfileViewController: MyPostTableViewCellDelegate {
  func promoteButtonDidPressed(post: Post) {
    print("Inside delegate promote")
    let vc = UIStoryboard(name: "PostPromotion", bundle: nil).instantiateViewController(withIdentifier: "PostPromotionVC") as! PostPromotionViewController
    print("Built vc")
    vc.post = post
    navigationController?.pushViewController(vc,animated:true)
  }
}

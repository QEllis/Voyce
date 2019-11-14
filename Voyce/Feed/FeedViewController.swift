//
//  FeedViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    UserManager.shared.initWithPlaceholderPosts()
    UserManager.shared.LoadFeed(); 
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
    }
  }
  
  @objc private func newPosts() {
    tableView.reloadData()
  }
  
  @IBAction func postPressed(_ sender: Any) {
    let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "PostCreationVC")
    navigationController?.pushViewController(vc, animated: true)
  }

}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "CommentCreationVC") as? CommentCreationViewController else { return }
    vc.post = UserManager.shared.posts[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension FeedViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserManager.shared.posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
    cell.fillOut(with: UserManager.shared.posts[indexPath.row])
    cell.delegate = self
    return cell
  }
  
}

extension FeedViewController: PostTableViewCellDelegate {
  func profileButtonDidPressed(postUser: User) {
    if(postUser.userID == UserManager.shared.sharedUser.userID){
      self.tabBarController?.selectedIndex = 1
    }
    else{
      let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
      vc.user = postUser
      navigationController?.pushViewController(vc,animated:true)
    }
  }
}


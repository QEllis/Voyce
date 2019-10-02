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
    UserManager.shared.initWithPlaceholderPosts()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
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

extension FeedViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserManager.shared.posts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
    cell.fillOut(with: UserManager.shared.posts[indexPath.row])
    return cell
  }

}

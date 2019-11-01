//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

final class MyPostTableViewCell: UITableViewCell {
  
  var delegate: PostTableViewCellDelegate?
  var postUser = User(userID: 0, name: "nil", username: "nil")

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!
  
  
    public func fillOut(with post: Post) {
    postUser = post.user
    layoutIfNeeded()
    usernameLabel.text = postUser.username
    textView.text = post.text
    createdAtLabel.text = "today"
  }
}

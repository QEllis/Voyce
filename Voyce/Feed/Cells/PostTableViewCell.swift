//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit


protocol PostTableViewCellDelegate {
  func profileButtonDidPressed(postUser: User)
}

final class PostTableViewCell: UITableViewCell {
  
  var delegate: PostTableViewCellDelegate?
  var postUser = User(userID: 0, name: "nil", username: "nil")

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!
  @IBOutlet weak var commentStackView: UIStackView!
  @IBOutlet var commentLabel1: UILabel!
  @IBOutlet var commentLabel2: UILabel!
  @IBOutlet var commentLabel3: UILabel!

  public func fillOut(with post: Post) {
    postUser = post.user
    layoutIfNeeded()
    usernameLabel.text = postUser.username
    textView.text = post.text
    createdAtLabel.text = "today"
    commentStackView.isHidden = !(post.comments.count > 0)

    for (index, comment) in post.comments.enumerated() {
      switch index {
      case 0:
        commentLabel1.isHidden = false
        commentLabel1.text = comment.text
      case 1:
        commentLabel2.isHidden = false
        commentLabel2.text = comment.text
      case 2:
        commentLabel3.isHidden = false
        commentLabel3.text = comment.text
      default:
        break
      }
    }
    
  }

  @IBAction func profileButtonPressed(_ sender: Any) {
    delegate?.profileButtonDidPressed(postUser: postUser)

  }
}

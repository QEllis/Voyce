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
  @IBOutlet weak var commentStackView: UIStackView!
  @IBOutlet weak var commentLabel: UILabel!

  public func fillOut(with post: Post) {
    postUser = post.user
    layoutIfNeeded()
    usernameLabel.text = postUser.username
    textView.text = post.text
    createdAtLabel.text = "today"
    commentLabel.isHidden = post.comments.count == 0
    for comment in post.comments {
      print("insert comment")
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
      label.text = comment.text
      //commentStackView.insertArrangedSubview(label, at: 0)
      commentLabel.text = comment.text
    }
    
  }
}

//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

final class PostTableViewCell: UITableViewCell {

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!

  public func fillOut(with post: Post) {
    layoutIfNeeded()
    usernameLabel.text = post.username
    textView.text = post.text
    createdAtLabel.text = "today"
  }

}

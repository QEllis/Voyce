//
//  PostCommentView.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class PostCommentView: UIView {

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var textView: UITextView!

  public func fillOut(with post: Post) {
    nameLabel.text = post.user.username
    dateLabel.text = DateFormatter().string(from: Date())
    textView.text = post.text
  }

}

//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

final class PostTableViewCell: UITableViewCell, UIViewController {

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!
  @IBOutlet weak var commentStackView: UIStackView!
  @IBOutlet weak var commentLabel: UILabel!

  public func fillOut(with post: Post) {
    layoutIfNeeded()
    usernameLabel.text = post.username
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

  @IBAction func profileButtonPressed(_ sender: Any) {
    let user = UserManager.sharedUser
    
    let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
    vc.user = user
    navigationController?.pushViewController(vc,animated:true)
    
//    navigationController?.pushViewController(vc, animated: true)
//
//    if let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedVC") as? FeedViewController {
//          vc.user = user
//          navigationController?.pushViewController(vc,animated:true)
//      }
  }
}

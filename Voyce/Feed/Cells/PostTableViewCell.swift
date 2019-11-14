//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit


protocol PostTableViewCellDelegate{
  func profileButtonDidPressed(postUser: User)
}


final class PostTableViewCell: UITableViewCell {
  
  var delegate: PostTableViewCellDelegate?
  var postUser = User(userID: "0", name: "nil", username: "nil")
  var post:Post = Post()
  
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!
  @IBOutlet weak var commentStackView: UIStackView!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var acknowledgeButton: UIButton!
  
  var acknowledged = false
  
  public func fillOut(with post: Post) {
    self.post = post
    postUser = post.user
    layoutIfNeeded()
    usernameLabel.text = postUser.username
    textView.text = post.text
    createdAtLabel.text = "today"
    commentLabel.isHidden = post.comments.count == 0
    for comment in post.comments {
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
      label.text = comment.text
      //commentStackView.insertArrangedSubview(label, at: 0)
      commentLabel.text = comment.text
    }
    
  }

  @IBAction func profileButtonPressed(_ sender: Any) {
    delegate?.profileButtonDidPressed(postUser: postUser)

  }
  
  @IBAction func acknowledgePressed(_ sender: Any) {
    print("acknowledge")
    acknowledged.toggle()
    switchButton()
  }
  
  func switchButton(){
    if(!acknowledged){
      acknowledgeButton.setImage(UIImage(named: "closed_eye"), for: .normal)
      UserManager.shared.removeAcknowledgedPost(post: post)
    }else{
      acknowledgeButton.setImage(UIImage(named: "eye_open"), for: .normal)
      UserManager.shared.addAcknowledgedPost(post: post)
    }
  }
  
  
}

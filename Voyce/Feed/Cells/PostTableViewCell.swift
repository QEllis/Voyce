//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate
{
    func profileButtonDidPressed(postUser: User)
}


final class PostTableViewCell: UITableViewCell
{
  var delegate: PostTableViewCellDelegate?
     var user = User.init()
    var currentUser: User = UserManager.shared.sharedUser
    var postUser: User?
  var post:Post = Post()
  
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var textView: UITextView!
  @IBOutlet weak var commentStackView: UIStackView!
  @IBOutlet var commentLabel1: UILabel!
  @IBOutlet var commentLabel2: UILabel!
  @IBOutlet var commentLabel3: UILabel!
  @IBOutlet weak var acknowledgeButton: UIButton!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var ackLabel: UILabel!
  @IBOutlet var imageHeightConstraint: NSLayoutConstraint!

  var acknowledged = false
  
  // Adds post to the feed
  public func fillOut(with post: Post)
  {
    self.post = post
    postUser = post.user
    layoutIfNeeded()
    usernameLabel.text = postUser?.username
    textView.text = post.text
    ackLabel.text = String(post.likeCount)
    createdAtLabel.text = "today"
    commentStackView.isHidden = !(post.comments.count > 0)

    if post.image == nil {
      imageHeightConstraint.constant = 0
    } else {
      imageHeightConstraint.constant = 300
      postImage.image = post.image
    }

    print("Comments count: \(post.comments.count)")
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

  @IBAction func profileButtonPressed(_ sender: Any)
  {
    print("Profile Button")
    delegate?.profileButtonDidPressed(postUser: currentUser)
  }
  
  @IBAction func acknowledgePressed(_ sender: Any) {
    print("acknowledge")
    acknowledged.toggle()
    switchButton()
  }
  
  // Add vibe to the post and removes vibes from current user
  func switchButton()
  {
    //if(!acknowledged){
      acknowledgeButton.setImage(UIImage(named: randomEmoji()), for: .normal)
    //let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
    //    print("FIRE!!!")
    //})
      //UserManager.shared.UnacknowledgedPost(post: post)
        ackLabel.text = String(post.likeCount)
    //}else{
      UserManager.shared.AcknowledgedPost(post: post)
    // Adding vibe to post user
     print("user has " + String(Int(postUser?.getVibes() ?? 0)) + " vibes")
      postUser?.addVibes(vibes: 1);
    
    print("after adding vibe user has " + String(Int(postUser?.getVibes() ?? 0)) + " vibes")
    print("Name" + String(postUser?.username ?? "Nil"))
    
    // Removing vibe from current user
    print("current user name is : " + currentUser.username)
    print("current user number of vibes : " + String(currentUser.getVibes()))
    currentUser.removeVibes()
    print("after removing vibes from current user number of vibes : " + String(currentUser.getVibes()))
    
    
      //ackLabel.text = String(post.likeCount)
   // }
  }
    
    //function that returns random emoji from assets.xcassets folder
    func randomEmoji() -> String! {
        var emojiArray = [String]()
        emojiArray.append("art-and-design")
        emojiArray.append("avocado")
        emojiArray.append("birthday-cake")
        emojiArray.append("bread")
        emojiArray.append("cake")
        emojiArray.append("crown")
        emojiArray.append("crowns")
        emojiArray.append("dog")
        emojiArray.append("eye-mask")
        emojiArray.append("falling-star")
        
        emojiArray.append("fan")
        emojiArray.append("fireworks")
        emojiArray.append("fort")
        emojiArray.append("gems")
        emojiArray.append("hat")
        emojiArray.append("hearts")
        emojiArray.append("ice-cream")
        emojiArray.append("icecream")
        emojiArray.append("idea")
        emojiArray.append("kissing")
        
        emojiArray.append("lips")
        emojiArray.append("love-letter")
        emojiArray.append("money-1")
        emojiArray.append("money-2")
        emojiArray.append("money")
        emojiArray.append("orchid")
        emojiArray.append("paint-palette")
        emojiArray.append("palette")
        emojiArray.append("party")
        emojiArray.append("phsyics")
        
        
        emojiArray.append("pizza")
        emojiArray.append("plastic-cup")
        emojiArray.append("rainbow")
        emojiArray.append("rose-1")
        emojiArray.append("rose-2")
        emojiArray.append("rose")
        emojiArray.append("shirt")
        emojiArray.append("space")
        emojiArray.append("spark")
        emojiArray.append("stars")
        
        
        emojiArray.append("strawberry")
        emojiArray.append("sun")
        emojiArray.append("thumbs-up")
        emojiArray.append("venus-de-milo")
        emojiArray.append("wand")
        emojiArray.append("yin-yang")
        
        let randomNumber = Int.random(in: 0..<46)
        return emojiArray[randomNumber]
    }
}

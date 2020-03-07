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
    var postUser = User(userID: "0", name: "nil", username: "nil")
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
    
    public func fillOut(with post: Post)
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 170/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 50
        
        self.post = post
        postUser = post.user
        layoutIfNeeded()
        usernameLabel.text = postUser.username
//        textView.text = post.text
        ackLabel.text = String(post.likeCount)
        createdAtLabel.text = "today"
//        commentStackView.isHidden = !(post.comments.count > 0)
        
//        if post.image == nil {
//            imageHeightConstraint.constant = 0
//        } else {
//            imageHeightConstraint.constant = 300
            postImage.image = post.image
//        }
        
//        print("Comments count: \(post.comments.count)")
//        for (index, comment) in post.comments.enumerated()
//        {
//            switch index
//            {
//            case 0:
//                commentLabel1.isHidden = false
//                commentLabel1.text = comment.text
//            case 1:
//                commentLabel2.isHidden = false
//                commentLabel2.text = comment.text
//            case 2:
//                commentLabel3.isHidden = false
//                commentLabel3.text = comment.text
//            default:
//                break
//            }
//        }
    }
    
    @IBAction func profileButtonPressed(_ sender: Any)
    {
        delegate?.profileButtonDidPressed(postUser: postUser)
    }
    
    @IBAction func acknowledgePressed(_ sender: Any)
    {
        print("acknowledge")
        acknowledged.toggle()
        switchButton()
    }
    
    func switchButton()
    {
        //if(!acknowledged){
        //acknowledgeButton.setImage(UIImage(named: "closed_eye"), for: .normal)
        acknowledgeButton.setImage(nil, for: .normal)
        //let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
        //    print("FIRE!!!")
        //})
        acknowledgeButton.setTitle(randomEmoji(), for: .normal)
        //UserManager.shared.UnacknowledgedPost(post: post)
        ackLabel.text = String(post.likeCount)
        //}else{
        //acknowledgeButton.setImage(UIImage(named: "eye_open"), for: .normal)
        UserManager.shared.AcknowledgedPost(post: post)
        //ackLabel.text = String(post.likeCount)
        // }
    }
    
    func randomEmoji() -> String!
    {
        var emojiArray = [String]()
        emojiArray.append("🤠")//cowboy
        emojiArray.append("😀")//grinning face
        emojiArray.append("🤣")//rofl
        emojiArray.append("😇")//smiling face with halo
        emojiArray.append("🤩")//star-struck
        emojiArray.append("😝")//squinting face with tongue
        emojiArray.append("🤪")//zany face
        emojiArray.append("🤨")//face with raised eyebrow
        emojiArray.append("😑")//expressionless face
        emojiArray.append("😐")//neutral face
        let randomNumber = Int.random(in: 0..<10)
        return emojiArray[randomNumber]
    }
}

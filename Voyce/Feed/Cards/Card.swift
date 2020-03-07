//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

protocol CardDelegate
{
    func profileButtonDidPressed(postUser: User)
}

final class Card: UITableViewCell
{
    
    var delegate: CardDelegate?
    var postUser = User(userID: "0", name: "nil", username: "nil")
    var post: Post = Post()
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var vibeButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var numVibes: UILabel!
    
    public func fillOut(with post: Post)
    {
        //Set border color and size of Card
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 170/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 50
        
        layoutIfNeeded()
        
        //Populate Card with associated information
        self.post = post
        postUser = post.user
        usernameLabel.text = postUser.username
        vibeButton.setImage(nil, for: .normal)
        vibeButton.setTitle(randomEmoji(), for: .normal)
        numVibes.text = String(post.likeCount)
        createdAtLabel.text = "today"
        postImage.image = post.image
    }
    
    @IBAction func profileButtonPressed(_ sender: Any)
    {
        delegate?.profileButtonDidPressed(postUser: postUser)
    }
    
    @IBAction func acknowledgePressed(_ sender: Any)
    {
        vibeButton.setImage(nil, for: .normal)
        vibeButton.setTitle(randomEmoji(), for: .normal)
        numVibes.text = String(post.likeCount)
        UserManager.shared.AcknowledgedPost(post: post)
    }
    
    func randomEmoji() -> String!
    {
        var emojiArray = [String]()
        emojiArray.append("🤠") //cowboy
        emojiArray.append("😀") //grinning face
        emojiArray.append("🤣") //rofl
        emojiArray.append("😇") //smiling face with halo
        emojiArray.append("🤩") //star-struck
        emojiArray.append("😝") //squinting face with tongue
        emojiArray.append("🤪") //zany face
        emojiArray.append("🤨") //face with raised eyebrow
        emojiArray.append("😑") //expressionless face
        emojiArray.append("😐") //neutral face
        
        let randomNumber = Int.random(in: 0..<10)
        return emojiArray[randomNumber]
    }
}

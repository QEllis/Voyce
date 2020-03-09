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
    var postUser: User = User(userID: "0", name: "nil", username: "nil")
    var currentUser: User = DatabaseManager.shared.sharedUser
    var post: Post = Post()
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var vibeButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var numVibes: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
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
        //profileButton.imageView = postUser.
        numVibes.text = String(post.likeCount)
        createdAtLabel.text = "today" //Add timestamp to Post
        
        let url = URL(string: post.image!)
        let data = try? Data(contentsOf: url!)
        postImage.image = UIImage(data: data!)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any)
    {
        delegate?.profileButtonDidPressed(postUser: postUser)
    }
    
    @IBAction func acknowledgePressed(_ sender: Any)
    {
        if(currentUser.hasUnusedVibes()){
            updateVibes()
            updateUI()
        }
    }
    
    func updateVibes()
    {
        postUser.addVibes(totalVibes: 1)
        currentUser.removeVibes()
    }
    
    func updateUI()
    {
        vibeButton.setImage(UIImage(named: randomEmoji()), for: .normal)
        DatabaseManager.shared.acknowledgePost(post: post)
        numVibes.text = String(post.likeCount)
    }
    
    func randomEmoji() -> String!
    {
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
        emojiArray.append("yin-yang")
        let randomNumber = Int.random(in: 0..<45)
        return emojiArray[randomNumber]
    }
}

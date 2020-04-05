//
//  Card.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 2/10/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class Card: UIView
{
    @IBOutlet var card: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var vibeButton: UIButton!
    @IBOutlet var numVibes: UILabel!
    @IBOutlet var profileButton: UIButton!
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postText: UITextView!
    @IBOutlet var postVideo: UIView!
    
    var user: User?
    var post: Post?
    
    // For using Card in Swift
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    // For using Card in InterfaceBuilder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("Card", owner: self, options: nil)
        addSubview(card)
        card.frame = self.bounds
        card.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Set border color and size of Card
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.init(red: 170/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        card.layer.cornerRadius = 50
        postImage.layer.cornerRadius = 50
        
        layoutIfNeeded()
    }
    
    /// Populate Card with associated information
    func addPost(post: Post) {
        self.post = post
        self.user = post.user
        usernameLabel.text = self.user?.username
        dateLabel.text = post.date
        numVibes.text = String(post.vibes)
        
        profileButton.setImage(URLToImg(user?.profilePic) ?? UIImage(named: "Profile"), for: .normal)
        circularImg(imageView: profileButton.imageView)
        
        switch post.postType {
        case "text":
            postText.text = post.content
        case "image":
            let url = URL(string: post.content)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                self.postImage.image = UIImage(data: data!)
            }
        case "video":
            let url = URL(string: post.content)
            if url != nil {
                let player = AVPlayer(url: url!)
                let playerFrame = CGRect(x: 0, y: 0, width: postVideo.frame.width, height: postVideo.frame.height)
                let videoPlayerView = VideoPlayerView(frame: playerFrame)
                videoPlayerView.player = player
                postVideo.addSubview(videoPlayerView)
                player.play()
                //Make sure to stop video when swiping away.
            }
        default:
            print("Error: Unknown Post Type for \(post.postID)")
        }
    }
    
    // Action when vibeButton is pressed
    @IBAction func vibeButtonPressed(_ sender: UIButton) {
        // Update vibes in the database
        user?.addVibes(totalVibes: 1)
        user?.addVibes(earnedVibes: 1)
        // Update UI
        vibeButton.setImage(randomEmoji(), for: .normal)
    }
    
    /// Action when profileButton is pressed.
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
    }
    
    /// Pause/Play video when postVideo is pressed.
    @IBAction func videoPressed(_ sender: UITapGestureRecognizer) {
        
    }
    
    // Returns a random emoji as UIImage
    private func randomEmoji() -> UIImage!
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
        return UIImage(named:emojiArray[randomNumber])
    }
    
    func URLToImg(_ url: URL?) -> UIImage?
    {
        guard let imageURL = url else
        {
            return nil
        }
        let data = try? Data(contentsOf: imageURL)
        return UIImage(data: data!)
    }
    
    /// Changes the shape of each profile image into a circle.
    func circularImg(imageView: UIImageView?)
    {
        imageView?.layer.cornerRadius = (imageView?.frame.height ?? 50.0) / 2.0
    }
}

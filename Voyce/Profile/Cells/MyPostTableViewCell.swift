//
//  PostTableViewCell.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

protocol MyPostTableViewCellDelegate{
    func promoteButtonDidPressed(post: Post)
}

final class MyPostTableViewCell: UITableViewCell {
    
    var delegate: MyPostTableViewCellDelegate?
    var postUser = User()
    var post: Post = Post()
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    
    public func fillOut(with post: Post) {
        layoutIfNeeded()
//        self.postUser = post.user   Make sure to add a query for this with userID
        self.post = post
        usernameLabel.text = postUser.username
        textView.text = post.content
        createdAtLabel.text = "today"
    }
    
    @IBAction func promoteButtonDidPressed(_ sender: Any) {
        print("promote button pressed")
        delegate?.promoteButtonDidPressed(post: post)
    }
}

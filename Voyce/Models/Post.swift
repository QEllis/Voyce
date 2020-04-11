//
//  Post.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class Post
{
    let postID: String
    let userID: String
    let date: String
    let postType: String
    let content: String
    var vibes: Int
    var caption: String
    
    var dictionary: [String: Any] {
        return [
            "userID": userID,
            "date": date,
            "postType": postType,
            "content": content,
            "vibes": vibes,
            "caption": caption,
        ]
    }
    
    init() {
        self.postID = ""
        self.userID = ""
        self.date = Date().description
        self.postType = ""
        self.content = ""
        self.vibes = 0
        self.caption = ""
    }
    
    init(pid: String, user: User, postType: String, content: String, caption: String) {
        self.postID = pid
        self.userID = user.userID
        self.date = NSDate().description
        self.postType = postType
        self.content = content
        self.vibes = 0
        self.caption = caption
    }
    
    init(pid: String, user: User, postType: String, content: String, vibes: Int, caption: String) {
        self.postID = pid
        self.userID = user.userID
        self.date = NSDate().description
        self.postType = postType
        self.content = content
        self.vibes = vibes
        self.caption = caption
    }
    
    init(pid: String, user: User, date: String, postType: String, content: String, vibes: Int, caption: String) {
        self.postID = pid
        self.userID = user.userID
        self.date = date
        self.postType = postType
        self.content = content
        self.vibes = vibes
        self.caption = caption
    }
    
    init(pid: String, userID: String, date: String, postType: String, content: String, vibes: Int, caption: String) {
        self.postID = pid
        self.userID = userID
        self.date = date
        self.postType = postType
        self.content = content
        self.vibes = vibes
        self.caption = caption
    }
    
    init(post: Post) {
        self.postID = post.postID
        self.userID = post.userID
        self.date = post.date
        self.postType = post.postType
        self.content = post.content
        self.vibes = post.vibes
        self.caption = post.caption
    }
    
    func addVibes(vibes: Int) {
        self.vibes += vibes
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["vibes": FieldValue.increment(Int64(vibes))])
    }
    
    func changeCaption(caption: String) {
        self.caption = caption
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["caption": caption])
    }
}

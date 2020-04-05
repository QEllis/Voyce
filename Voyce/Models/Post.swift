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
    let user: User
    let userID: String
    let date: String
    let postType: String
    let content: String
    var vibes: Int
    var caption: String
    var comments: [Comment]
    
    var dictionary: [String: Any] {
        return [
            "uid": user.userID,
            "date": date,
            "postType": postType,
            "content": content,
            "vibes": vibes,
            "caption": caption,
            "comments": comments
        ]
    }
    
    init() {
        self.postID = ""
        self.user = User()
        self.userID = ""
        self.date = Date().description
        self.postType = ""
        self.content = ""
        self.vibes = 0
        self.caption = ""
        self.comments = []
    }
    
    init(pid: String, user: User, postType: String, content: String, caption: String) {
        self.postID = pid
        self.user = user
        self.userID = user.userID
        self.date = Date().description
        self.postType = postType
        self.content = content
        self.vibes = 0
        self.caption = caption
        self.comments = []
    }
    
    init(pid: String, user: User, postType: String, content: String, vibes: Int, caption: String) {
        self.postID = pid
        self.user = user
        self.userID = user.userID
        self.date = Date().description
        self.postType = postType
        self.content = content
        self.vibes = vibes
        self.caption = caption
        self.comments = []
    }
    
    init(pid: String, user: User, date: String, postType: String, content: String, vibes: Int, caption: String) {
        self.postID = pid
        self.user = user
        self.userID = user.userID
        self.date = date
        self.postType = postType
        self.content = content
        self.vibes = vibes
        self.caption = caption
        self.comments = []
    }
    
    init(post: Post) {
        self.postID = post.postID
        self.user = post.user
        self.userID = user.userID
        self.date = post.date
        self.postType = post.postType
        self.content = post.content
        self.vibes = post.vibes
        self.caption = post.caption
        self.comments = post.comments
    }
    
    func addVibe() {
        self.vibes += 1
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["vibes": FieldValue.increment(Int64(1))])
    }
    
    func changeCaption(caption: String) {
        self.caption = caption
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["caption": caption])
    }
    
    func addComment(comment: Comment) {
        self.comments.append(comment)
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["comments": comments])
    }
    
    func removeComment(index: Int) {
        
        self.comments.remove(at: index)
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID)
        sharedRef.updateData(["comments": comments])
    }
    
    ///Add functions to update values of Comments in the database.
}

//
//  Comment.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/19/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class Comment
{
    let commentID: String
    let userID: String
    let date: String
    var content: String
    var vibes: Int
    
    var dictionary: [String: Any] {
        return [
            "userID": userID,
            "date": date,
            "content": content,
            "vibes": vibes,
        ]
    }
    
    init(commentID: String, userID: String, content: String) {
        self.commentID = commentID
        self.userID = userID
        self.date = Date().description;
        self.content = content;
        self.vibes = 0;
    }
    
    init(commentID: String, userID: String, content: String, vibes: Int) {
        self.commentID = commentID
        self.userID = userID
        self.date = Date().description;
        self.content = content;
        self.vibes = vibes;
    }
    
    init(commentID: String, userID: String, date: String, content: String, vibes: Int) {
        self.commentID = commentID
        self.userID = userID
        self.date = date;
        self.content = content;
        self.vibes = vibes;
    }
    
    init(comment: Comment) {
        self.commentID = comment.commentID
        self.userID = comment.userID
        self.date = comment.date;
        self.content = comment.content;
        self.vibes = comment.vibes;
    }
    
    func changeContent(postID: String, content: String) {
        self.content = content
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID).collection("comments").document(commentID)
        sharedRef.updateData(["content": content])
    }
    
    func addVibes(postID: String, vibes: Int) {
        self.vibes += 1
        
        let sharedRef = DatabaseManager.shared.db.collection("posts").document(postID).collection("comments").document(commentID)
        sharedRef.updateData(["vibes": FieldValue.increment(Int64(vibes))])
        
        let userRef = DatabaseManager.shared.db.collection("users").document(userID)
        userRef.updateData(["totalVibes": FieldValue.increment(Int64(vibes))])
        userRef.updateData(["earnedVibes": FieldValue.increment(Int64(vibes))])
    }
}

//
//  Comment.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/19/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit

public class Comment
{
    let commentID: String
    let user: User
    let userID: String
    let date: String
    var content: String
    var vibes: Int
    
    var dictionary: [String: Any] {
        return [
            "userID": user.userID,
            "date": date,
            "content": content,
            "vibes": vibes,
        ]
    }
    
    init(commentID: String, user: User, content: String) {
        self.commentID = commentID
        self.user = user;
        self.userID = user.userID
        self.date = Date().description;
        self.content = content;
        self.vibes = 0;
    }
    
    init(commentID: String, user: User, content: String, vibes: Int) {
        self.commentID = commentID
        self.user = user;
        self.userID = user.userID
        self.date = Date().description;
        self.content = content;
        self.vibes = vibes;
    }
    
    init(comment: Comment) {
        self.commentID = comment.commentID
        self.user = comment.user;
        self.userID = user.userID
        self.date = comment.date;
        self.content = comment.content;
        self.vibes = comment.vibes;
    }
    
    func changeContent(content: String) {
        self.content = content
    }
    
    func addVibe() {
        self.vibes += 1
    }
}

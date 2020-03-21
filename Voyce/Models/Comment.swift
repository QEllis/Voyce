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
    var userID: String //ID of user that posted
    let timeStamp: TimeInterval //date posted
    let content: String //text
    var vibes: Int
    var postID: String
    
    init() {
        self.commentID = ""
        self.timeStamp = NSDate().timeIntervalSince1970;
        self.content = ""
        self.vibes = 0
        self.userID = "";
        self.postID = "";
    }
    
    init(commentID: String, content: String, userID: String, postID: String, timeStamp: TimeInterval, vibes: Int){
        self.commentID = commentID
        self.content = content;
        self.userID = userID;
        self.postID = postID;
        self.timeStamp = timeStamp;
        self.vibes = vibes;
        
    }
}

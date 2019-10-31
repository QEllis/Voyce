//
//  Post.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

public class Post {

  let text: String
  var user: User
  //username needs to pull from User
  let username: String
  let likeCount: Int
  var comments: [Post]

  //pull from database
  init(text: String, username: String, likeCount: Int) {
    self.text = text
    self.username = username
    self.likeCount = likeCount
    self.comments = []
    self.user = User(userID: 0, name:"Frank Pol", username: "franky")
  }

  public func addComment(_ comment: Post) {
    comments.append(comment)
  }

}

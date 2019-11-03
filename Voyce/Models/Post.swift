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
  init(text: String, user: User, likeCount: Int) {
    self.text = text
    self.user = user
    self.username = user.username
    self.likeCount = likeCount
    self.comments = []
  }

  public func addComment(_ comment: Post) {
    comments.append(comment)
  }

}

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
  let username: String
  let likeCount: Int
  var comments: [Post]

  init(text: String, username: String, likeCount: Int) {
    self.text = text
    self.username = username
    self.likeCount = likeCount
    self.comments = []
  }

  public func addComment(_ comment: Post) {
    comments.append(comment)
  }

}

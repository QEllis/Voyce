//
//  Post.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

public class Post {

    let postID: String
  let text: String
    let media: String
  let username: String
  let likeCount: Int
  var comments: [Post]

    init(pid:String, text: String, media: String, username: String, likeCount: Int) {
        self.postID = pid
    self.text = text
        self.media = media
    self.username = username
    self.likeCount = likeCount
    self.comments = []
  }

  public func addComment(_ comment: Post) {
    comments.append(comment)
  }

}

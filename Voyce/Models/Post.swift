//
//  Post.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

public class Post {
  var id:String
  let text: String
  var user: User
  //username needs to pull from User
  let username: String
  let likeCount: Int
  var comments: [Post]
  
  init() {
    self.id = "nil"
    self.text = "nil"
    self.user = User()
    self.username = user.username
    self.likeCount = 0
    self.comments = []
  }
  
  //pull from database
  init(id:String, text: String, user: User, likeCount: Int) {
    self.id = id
    self.text = text
    self.user = user
    self.username = user.username
    self.likeCount = likeCount
    self.comments = []
  }
  
  init(post:Post){
    self.id = post.id
    self.text = post.text
    self.user = post.user
    self.username = post.username
    self.likeCount = post.likeCount
    self.comments = post.comments
  }
  
  public func addComment(_ comment: Post) {
    comments.append(comment)
  }
  
}

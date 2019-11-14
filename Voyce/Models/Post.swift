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
  let likeCount: Int
  var user: User
  var comments: [Post]

  init(pid:String, text: String, media: String, user: User, likeCount: Int) {
    self.postID = pid
    self.text = text
    self.media = media
    self.user = user
    self.likeCount = likeCount
    self.comments = []
  }
  
  init(){
    self.postID = ""
    self.text = ""
    self.media = ""
    self.user = User()
    self.likeCount = 0
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

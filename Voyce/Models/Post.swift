//
//  Post.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

public class Post {
  
  let postID: String
  let text: String
  let media: String
  var likeCount: Int
  var user: User
  var comments: [Post]
  var image: UIImage?
    
    var dictionary: [String: Any] {
      return [
      "text": text,
      "media": media,
      "uid": user.userID,
      "likeCount": likeCount,
      "comments": comments
      ]
    }

  init(pid:String, text: String, media: String, user: User, likeCount: Int, image: UIImage? = nil) {
    self.postID = pid
    self.text = text
    self.media = media
    self.user = user
    self.likeCount = likeCount
    self.comments = []
    self.image = image
  }
  
  init(){
    self.postID = ""
    self.text = ""
    self.media = ""
    self.user = User()
    self.likeCount = 0
    self.comments = []
  }
  
  init(post: Post){
    self.postID = post.postID
    self.text = post.text
    self.media = post.media
    self.user = post.user
    self.likeCount = post.likeCount
    self.comments = post.comments
    self.image = post.image
  }
  
  public func addComment(_ comment: Post) {
    print("comments count before: \(comments.count)")
    comments.append(comment)
    print("Comments count: \(comments.count)")
  }
  
}

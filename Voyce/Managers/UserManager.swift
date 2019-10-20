//
//  UserManager.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

class UserManager {

  static let shared = UserManager()

  var posts: [Post] = [] {
    didSet {
      NotificationCenter.default.post(name: .NewPosts, object: nil)
    }
  }

  public func initWithPlaceholderPosts() {
    posts.append(Post(text: "First Post", username: "quinn", likeCount: 19))
    posts.append(Post(text: "Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post ", username: "quinn", likeCount: 119))
    posts.append(Post(text: "quinn", username: "quinn", likeCount: 1119))
  }

  public func addPost(with text: String) {
    posts.insert(Post(text: text, username: "quinn", likeCount: 0), at: 0)
  }
  
  //need to load in user from database
  static let sharedUser = User.init(userID: 0, name: "Test Johnson", username: "Testing")
  
  public func addFollowed(username:String){
    UserManager.sharedUser.addFollowed(username: username)
  }
  public func removeFollowed(username:String){
    UserManager.sharedUser.removeFollowed(username: username)
  }
  
  public func checkIfFollowed(username:String)->Bool{
    return UserManager.sharedUser.checkIfFollowed(username: username)
  }
  

  //temp username and password storage
  var username = "q"
  var email = "q"
  var password = "q"

}

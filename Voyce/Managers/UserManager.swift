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
  
  var dislikedAds: [String] = []
  var acknowledgedPosts:[String:Post] = [:]
  
  public func checkAcknowledgedPost(post:Post)->Bool{
    if(acknowledgedPosts[post.id] != nil){
      return true
    }
    else{
      return false
    }
  }
  
  public func addAcknowledgedPost(post:Post){
    if(!checkAcknowledgedPost(post: post)){
      print("Acknowledged Post")
      acknowledgedPosts[post.id] = post
    }
  }

  public func removeAcknowledgedPost(post:Post){
    if(checkAcknowledgedPost(post: post)){
      print("Deacknowledged Post")
      acknowledgedPosts.removeValue(forKey: post.id)
    }
  }
  
  public func initWithPlaceholderPosts() {
    var otherUser:User = User(userID: 3, name: "Frank Pol", username: "franky", goodVibes: 9001)
//    posts.append(Post(text: "First Post", username: "quinn", likeCount: 19))
    posts.append(Post(id:"1", text: "First Post", user: otherUser , likeCount: 19))
    
    posts.append(Post(id: "2", text: "Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post ", user: UserManager.sharedUser, likeCount: 119))
    posts.append(Post(id:"3", text: "quinn", user: otherUser, likeCount: 1119))
  }
  
  public func addPost(with text: String) {
    posts.insert(Post(id:"4", text: text, user: UserManager.sharedUser, likeCount: 0), at: 0)
    myPosts.insert(Post(id:"5", text: text, user: UserManager.sharedUser, likeCount: 0), at: 0)
  }
  
  public func addComment(with text: String, post: Post) {
    for currPost in posts where currPost.text == post.text {
      print("addComment")
      let comment = Post(id:"6", text: text, user: UserManager.sharedUser, likeCount: 0)
      currPost.addComment(comment)
      NotificationCenter.default.post(name: .NewPosts, object: nil)
      return
    }
  }
  
  //need to load in user from database
  static let sharedUser = User.init(userID: 0, name: "Test Johnson", username: "Testing")
  
  //This array holds only posts made by the user, to present them in the profile
  //whenever the user makes a post also add it to this array
  var myPosts: [Post] = []
  
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

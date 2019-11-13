//
//  UserManager.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore


class UserManager {
  
  static let shared = UserManager()
  
  //is loaded in from DB on login
  var sharedUser = User.init(userID: "0", name: "null", username: "null")
    
  var db = Firestore.firestore();
    
  var myPosts: [Post] = []
  
  var posts: [Post] = [] {
    didSet {
      NotificationCenter.default.post(name: .NewPosts, object: nil)
    }
  }
    
    public func userLogin(u: FirebaseAuth.User){
        sharedUser  = User.init(user: u)
        let collection = db.collection("users");
        let userDoc = collection.document(u.uid)

        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("User data: \(dataDescription)")
                self.sharedUser.LoadUserData(dataDict: document.data()!)
            } else {
                print("User does not exist yet, create in db", u.uid)
    //                collection.addDocument(data: self.sharedUser.dictionary)
                userDoc.setData(self.sharedUser.dictionary)
            }
        }

    }
    
  
//  public func initWithPlaceholderPosts() {
//    var otherUser:User = User(userID: 3, name: "Frank Pol", username: "franky", goodVibes: 9001)
////    posts.append(Post(text: "First Post", username: "quinn", likeCount: 19))
//    posts.append(Post(text: "First Post", user: otherUser , likeCount: 19))
//    
//    posts.append(Post(text: "Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post Long post ", user: UserManager.shared.sharedUser, likeCount: 119))
//    posts.append(Post(text: "quinn", user: otherUser, likeCount: 1119))
//  }
  
  public func addPost(with text: String) {
//    posts.insert(Post(text: text, user: UserManager.shared.sharedUser, likeCount: 0), at: 0)
//    myPosts.insert(Post(text: text, user: UserManager.shared.sharedUser, likeCount: 0), at: 0)
    
    let id = UUID()
    let newPost = Post(pid:id.uuidString, text: text, media: "", user: sharedUser, likeCount: 0)
    
    //TODO: remove
    posts.insert(newPost, at: 0)
    
    db.collection("posts").document(id.uuidString).setData([
        "uid": sharedUser.userID,
        "text": text,
        "media": "",
        "likeCount": 0
    ]) { err in
        if let err = err {
            print("Error writing post to db: \(err)")
        } else {
            print("post successfully written to db!")
        }
    }
  }
  
  public func addComment(with text: String, post: Post) {
    for currPost in posts where currPost.text == post.text {
    let id = UUID()
      print("addComment")
        let comment = Post(pid: id.uuidString,text: text,media: "", user: UserManager.shared.sharedUser, likeCount: 0)
      currPost.addComment(comment)
      NotificationCenter.default.post(name: .NewPosts, object: nil)
      return
    }
  }
  public func addFollowed(username:String){
    UserManager.shared.sharedUser.addFollowed(username: username)
  }
  public func removeFollowed(username:String){
    UserManager.shared.sharedUser.removeFollowed(username: username)
  }
  
  public func checkIfFollowed(username:String)->Bool{
    return UserManager.shared.sharedUser.checkIfFollowed(username: username)
  }
  
  
  //temp username and password storage
  var username = "q"
  var email = "q"
  var password = "q"
}

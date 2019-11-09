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
    
  //need to load in user from database
    var sharedUser = User.init(userID: "0", name: "null", username: "null")

    //TODO: This users feed?
  var posts: [Post] = [] {
    didSet {
      NotificationCenter.default.post(name: .NewPosts, object: nil)
    }
  }
    
    public func userLogin(u: FirebaseAuth.User){
        sharedUser  = User.init(user: u)
        let collection = Firestore.firestore().collection("users");
        let userDoc = collection.document(u.uid)

        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("User data: \(dataDescription)")
                self.sharedUser.LoadUserData(dataDict: document.data()!)
            } else {
                print("User does not exist yet, create in db")
                collection.addDocument(data: self.sharedUser.dictionary)
            }
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

  public func addComment(with text: String, post: Post) {
    for currPost in posts where currPost.text == post.text {
      print("addComment")
      let comment = Post(text: text, username: "quinn", likeCount: 0)
      currPost.addComment(comment)
      NotificationCenter.default.post(name: .NewPosts, object: nil)
      return
    }
  }
  
  
  public func addFollowed(username:String){
    sharedUser.addFollowed(username: username)
  }
  public func removeFollowed(username:String){
    sharedUser.removeFollowed(username: username)
  }
  
  public func checkIfFollowed(username:String)->Bool{
    return sharedUser.checkIfFollowed(username: username)
  }
}

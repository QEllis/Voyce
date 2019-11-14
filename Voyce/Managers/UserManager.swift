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
  
//  public func addPost(with text: String) {
//    posts.insert(Post(id:"4", text: text, user: UserManager.sharedUser, likeCount: 0), at: 0)
//    myPosts.insert(Post(id:"5", text: text, user: UserManager.sharedUser, likeCount: 0), at: 0)
//  }
    
  public func userLogin(u: FirebaseAuth.User){
    sharedUser  = User.init(user: u)
    let collection = db.collection("users");
    let userDoc = collection.document(u.uid)

    userDoc.getDocument { (document, error) in
      if let document = document, document.exists {
          self.sharedUser.LoadUserData(dataDict: document.data()!)
      } else {
          print("User does not exist yet, create in db", u.uid)
          userDoc.setData(self.sharedUser.dictionary)
      }
    }

  }
  
  public func addPost(with text: String) {
    let id = UUID()
//    let newPost = Post(pid:id.uuidString, text: text, media: "", user: sharedUser, likeCount: 0)
    
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
    
    public func SetPostsUser(uid: String, p:Post){
        
        let collection = db.collection("users")
        collection.document(uid)
            .getDocument() { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let dataDescription = data.map(String.init(describing:)) ?? "nil"
                    print("GET USER Doc id: \(document.documentID)")
                    print("GET USER Document data: \(dataDescription)")
                    let actualUserFound = User(userID: document.documentID,
                                        name:  document.get("name") as! String,
                                        username:  document.get("username") as! String,
                                        imageURL:  document.get("imageURL") as! String,
                                        goodVibes:  document.get("goodvibes")  as! Int)
                    p.user = actualUserFound
                    print("Post Creator: \(p.user.userID)")
                } else {
                    print("User does not exist")
                }
            }
    }
  
    public func LoadFeed(){
        print("IN LOAD FEED");
        let collection = db.collection("posts")
        collection.order(by: "ts").limit(to: 10)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let p = Post(pid: document.documentID,
                                     text: data["text"] as! String,
                                     media: data["media"] as! String,
                                     user: User(),
                                     likeCount: data["likeCount"] as! Int)
                        self.SetPostsUser(uid: data["uid"] as! String, p: p)
                        self.posts.append(p)
                        print("POST: \(document.documentID) => \(document.data())")
                    }
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

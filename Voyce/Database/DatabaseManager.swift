//
//  UserManager.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

import FirebaseCore
import FirebaseFirestoreSwift

class DatabaseManager
{
    static let shared = DatabaseManager()
    
    var sharedUser: User
    var db: Firestore
    let storage: Storage
    var numPosts: Int
    var otherUsers: [User]
    var myPosts: [Post]
    {
        didSet
        {
            NotificationCenter.default.post(name: .NewPosts, object: nil)
        }
    }
    var index: Int //Will be changed to individual user's index
    
    init()
    {
        sharedUser = User.init()
        db = Firestore.firestore()
        storage = Storage.storage()
        numPosts = 0
        otherUsers = []
        myPosts = []
        index = 0
        
        db.collection("posts").addSnapshotListener() { querySnapshot, error in
            guard querySnapshot?.documents != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            let num = querySnapshot?.count
            print("Current data: \(num ?? -1)")
        }
        
        db.collection("posts").whereField("userID", isEqualTo: sharedUser.userID).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    let postID = data["postID"] as! String
                    let userID = data["userID"] as! String
                    let user = self.userIDtoUser(userID: userID)
                    let date = data["date"] as! String
                    let postType = data["postType"] as! String
                    let content = data["content"] as! String
                    let vibes = data["vibes"] as! Int
                    let caption = data["caption"] as! String
                    
                    let post = Post(pid: postID, user: user, date: date, postType: postType, content: content, vibes: vibes, caption: caption)
                    self.myPosts.append(post)
                }
            }
            
        }
    }
    
    /// Called when the user logs in.
    public func userLogin(u: FirebaseAuth.User)
    {
        sharedUser = User.init(user: u)
        let collection = db.collection("users");
        let userDoc = collection.document(u.uid)
        userDoc.getDocument { (document, error) in
            if let document = document, document.exists
            {
                self.sharedUser.loadUserData(document: document)
            }
            else
            {
                userDoc.setData(self.sharedUser.dictionary)
                print("User does not exist yet. New user added to database.", u.uid)
            }
        }
    }
    
    // Adds image post to database -- Needs work
    public func addPost(post: Post) {
        let id = UUID()
        //                let newPost = Post(pid: "0", text: text, media: "", user: sharedUser, likeCount: 0, image: image)
        //                myPosts.insert(newPost, at: 0)
        //                posts.insert(newPost, at: 0)
        myPosts.append(post)
        db.collection("posts").document(id.uuidString).setData([
            "caption": post.caption,
            "content": post.content,
            "date": post.date,
            "postID": id,
            "postType": post.postType,
            "userID": post.userID,
            "vibes": post.vibes,
            "comments": post.comments
        ]) { err in
            if let err = err {
                print("Error writing post to db: \(err)")
            } else {
                print("image post successfully written to db!")
            }
        }
    }
    
    public func loadFeed(view: FeedViewController, firstCard: Bool)
    {
        let numLoad = (numPosts - index) > 1 ? 2 : (numPosts - index)
        
        db.collection("posts").order(by: "date").start(at: ["2020-03-22 15:24:44 +0000"]).limit(to: 1).getDocuments() { QuerySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents
                {
                    let data = document.data()
                    let postID = data["postID"] as! String
                    let userID = data["userID"] as! String
                    let user = self.userIDtoUser(userID: userID)// Fix
                    let date = data["date"] as! String
                    let postType = data["postType"] as! String
                    let content = data["content"] as! String
                    let vibes = data["vibes"] as! Int
                    let caption = data["caption"] as! String
                    
                    let post = Post(pid: postID, user: user, date: date, postType: postType, content: content, vibes: vibes, caption: caption)
                    
                    switch view.counter % 2 {
                    case 0:
                        view.activeCard.addPost(post: post)
                        view.activeCard.isHidden = false
                    case 1:
                        view.queueCard.addPost(post: post)
                        view.queueCard.isHidden = false
                    default: print("Error: counter is an invalid integer.")
                    }
                    view.counter += 1
                    if firstCard { view.activeCard.playVideo() }
                }
            }
        }
        //        switch numLoad
        //        {
        //        case _ where numLoad < 1: view.queueCard.isHidden = true
        //        case _ where numLoad < 2: view.activeCard.isHidden = true
        //        default: break
        //        }
        
        self.index += 1
    }
    
    private func userIDtoUser(userID: String) -> User {
        var user: User = User()
        
        let ref = db.collection("users")
        ref.getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents
                {
                    if document.documentID == userID {
                        let data = document.data()
                        let userID = document.documentID
                        let name = data["name"] as! String
                        let username = data["username"] as! String
                        let adVibes = data["adVibes"] as! Int
                        let earnedVibes = data["earnedVibes"] as! Int
                        let totalVibes = data["totalVibes"] as! Int
                        let profilePic = data["profilePic"] as! String
                        
                        user = User(userID: userID, name: name, username: username, adVibes: adVibes, earnedVibes: earnedVibes, totalVibes: totalVibes, profilePic: profilePic)
                    }
                }
            }
        }
        return user
    }
    
    /* Comment functionality portion below */
    
    //creates comment from text, ID of commenter, and post on which commented
    public func addComment(content: String, userID: String, postID: String) {
        //        let vibes = 0
        //        let id = UUID()
        //        db.collection("comments").document(id.uuidString).setData([
        //            "postID": postID,
        //            "userID": userID,
        //            "ts": NSDate().timeIntervalSince1970,
        //            "content": content,
        //            "vibes": vibes,
        //            "commentID": id.uuidString
        //            ]) { err in
        //                if let err = err {
        //                    print("Error writing post to db: \(err)")
        //                } else {
        //                        print("post successfully written to db!")
        //                }
        //            }
        
    }
    
    /* Load all comments of a specific post and populates the DatabaseManager.comments[] member */
    public func loadComments(postID: String){
//        db.collection("comments").whereField("postID", isEqualTo: postID).order(by: "vibes", descending: true)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    self.comments = []
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                        let currComment = Comment(commentID: data["commentID"] as! String,
//                                                  content: data["content"] as! String,
//                                                  userID: data["userID"] as! String,
//                                                  postID: data["postID"] as! String,
//                                                  timeStamp: data["ts"] as! TimeInterval,
//                                                  vibes: data["vibes"] as! Int)
//
//                        print(currComment)
//                        self.comments.append(currComment)
//                    }
//                }
//        }
    }
    
    /* Helper function that returns true if current user is owner of comment object */
    
    /* If the current signed in user is the one who commented, then the comment object is removed from DB. Otherwise nothing happens */
    public func removeComment(currComment: Comment) {
        //        if(isCommenter(currComment: currComment)){
        //            db.collection("comments").document(currComment.commentID).delete() { err in
        //                if let err = err {
        //                    print("Error removing comment: \(err)")
        //                } else {
        //                    print("Comment successfully removed!")
        //                }
        //            }
        //        }
    }
    
    /* If the current signed in user is the one who commented, then comment is modified given the new text */
    public func editComment(currComment: Comment, newText: String){
        //        if(isCommenter(currComment: currComment)){
        //
        //        }
    }
    
    // Loads all other users from the database
    public func loadOtherUsers()
    {
        let collection = db.collection("users")
        collection.order(by: "totalVibes", descending: true).limit(to: 10).getDocuments()
        {
            (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                // Iterates trough all users in the database
                for document in querySnapshot!.documents
                {
                    let uid = document.documentID
                    if uid != self.sharedUser.userID {
                        let name = document.get("name") as! String
                        let username = document.get("username") as! String
                        let adVibes = document.get("adVibes") as! Int
                        let earnedVibes = document.get("earnedVibes") as! Int
                        let totalVibes = document.get("totalVibes") as! Int
                        let profilePic = document.get("profilePic") as! String
    
                        let user = User(userID: uid, name: name, username: username, adVibes: adVibes, earnedVibes: earnedVibes, totalVibes: totalVibes, profilePic: profilePic)
                        self.otherUsers.append(user)
                    }
                }
                print("OtherUsers: \(self.otherUsers)")
            }
        }
    }
}

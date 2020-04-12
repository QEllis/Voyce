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
    var otherUsers: [User]
    var index: Int
    var myPosts: [Post]
    var comments: [Comment]
    
    init()
    {
        sharedUser = User.init()
        db = Firestore.firestore()
        storage = Storage.storage()
        otherUsers = []
        index = 0
        myPosts = []
        comments = []
        
        db.collection("posts").whereField("userID", isEqualTo: sharedUser.userID).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    let postID = data["postID"] as! String
                    let userID = data["userID"] as! String
                    let date = data["date"] as! String
                    let postType = data["postType"] as! String
                    let content = data["content"] as! String
                    let vibes = data["vibes"] as! Int
                    let caption = data["caption"] as! String
                    
                    let post = Post(pid: postID, userID: userID, date: date, postType: postType, content: content, vibes: vibes, caption: caption)
                    self.myPosts.append(post)
                }
            }
            
        }
    }
    
    /// Called when the user logs in.
    public func userLogin(u: FirebaseAuth.User)
    {
        sharedUser = User.init(user: u)
        let collection = db.collection("users")
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
        myPosts.append(post)
        
        db.collection("posts").document(id.uuidString).setData([
            "caption": post.caption,
            "content": post.content,
            "date": post.date,
            "postID": id,
            "postType": post.postType,
            "userID": post.userID,
            "vibes": post.vibes,
        ]) { err in
            if let err = err {
                print("Error writing post to db: \(err)")
            } else {
                print("image post successfully written to db!")
            }
        }
    }
    
    public func postSeen(postID: String, userID: String) {
        db.collection("postsSeen").document(postID).setData([
            "posts": FieldValue.arrayUnion([userID])
        ])
    }
    
    /* Comment functionality portion below */
    
    //creates comment from text, ID of commenter, and post on which commented
    public func addComment(content: String, userID: String, postID: String) {
        db.collection("posts").document(postID).collection("comments").document().setData([
            "userID": userID,
            "date": Date().description,
            "content": content,
            "vibes": 0
        ]) { err in
            if let err = err {
                print("Error writing comment to db: \(err)")
            } else {
                print("Comment successfully written to db!")
            }
        }
        
    }
    
    /* Load all comments of a specific post and populates the DatabaseManager.comments[] member */
    public func loadComments(postID: String){
        db.collection("posts").document(postID).collection("comments").order(by: "vibes", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.comments = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let commentID = document.documentID
                        let userID = data["userID"] as! String
                        let date = data["date"] as! String
                        let content = data["content"] as! String
                        let vibes = data["vibes"] as! Int
                        
                        let comment = Comment(commentID: commentID, userID: userID, date: date, content: content, vibes: vibes)
                        
                        self.comments.append(comment)
                    }
                }
        }
    }
    
    /* Helper function that returns true if current user is owner of comment object */
    
    /* If the current signed in user is the one who commented, then the comment object is removed from DB. Otherwise nothing happens */
    public func removeComment(postID: String, commentID: String) {
        db.collection("posts").document(postID).collection("comments").document(commentID).delete()
    }
    
    /* If the current signed in user is the one who commented, then comment is modified given the new text */
    public func editComment(currComment: Comment, newText: String) {
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
                }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}

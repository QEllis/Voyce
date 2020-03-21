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

class DatabaseManager
{
    // Member Variables
    static let shared = DatabaseManager()
    var sharedUser: User
    var db: Firestore
    let storage: Storage
    var dislikedAds: [String]
    var acknowledgedPosts:[String:Post]
    var myPosts: [Post]  
    var posts: [Post] = []
    var comments: [Comment] = []
    {
        didSet
        {
            NotificationCenter.default.post(name: .NewPosts, object: nil)
        }
    }
    
    // Class Constructor
    init()
    {
        sharedUser = User.init()
        db = Firestore.firestore()
        storage = Storage.storage()
        dislikedAds = []
        acknowledgedPosts = [:]
        myPosts  = []
    }
    
    // Gives a vibe from one use to the other -- Needs work
    public func giveVibe(post: Post)
    {
        post.likeCount += 1;
        //    db.collection("posts").document(post.postID).setData(["likeCount":post.likeCount], merge: true);
        //
        let shardRef = DatabaseManager.shared.db.collection("posts").document(post.postID)
        shardRef.updateData(["likeCount": FieldValue.increment(Int64(1))])
    }
    
    // Called when the user logs in
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
    public func addPost(with text: String, image: String) {
        let id = UUID()
        let newPost = Post(pid: "0", text: text, media: "", user: sharedUser, likeCount: 0, image: image)
        myPosts.insert(newPost, at: 0)
        posts.insert(newPost, at: 0)
        db.collection("posts").document(id.uuidString).setData([
            "uid": sharedUser.userID,
            "ts": NSDate().timeIntervalSince1970,
            "text": text,
            "media": "",
            "likeCount": 0,
            "image": ""
        ]) { err in
            if let err = err {
                print("Error writing post to db: \(err)")
            } else {
                print("image post successfully written to db!")
            }
        }
    }
    
    // Adds text post to database -- Should work
    public func addPost(with text: String)
    {
        let id = UUID()
        let newPost = Post(pid: "-1", text: text, media: "", user: sharedUser, likeCount: 0)
        myPosts.insert(newPost, at: 0)
        posts.insert(newPost, at: 0)
        db.collection("posts").document(id.uuidString).setData([
            "uid": sharedUser.userID,
            "ts": NSDate().timeIntervalSince1970,
            "text": text,
            "media": "",
            "likeCount": 0,
            "postID": id.uuidString
        ]) { err in
            if let err = err {
                print("Error writing post to db: \(err)")
            } else {
                print("post successfully written to db!")
            }
        }
    }
    
    // Links a user to a post
    public func setPostsUser(uid: String, p: Post)
    {
        let collection = db.collection("users")
        collection.document(uid).getDocument() { (document, error) in
            if let document = document, document.exists
            {
                let data = document.data()
                let dataDescription = data.map(String.init(describing:)) ?? "nil"
                print("GET USER Doc id: \(document.documentID)")
                print("GET USER Document data: \(dataDescription)")
                let actualUserFound = User(userID: document.documentID, name:  document.get("name") as! String, username:  document.get("username") as! String, totalVibes:  document.get("totalVibes")  as! Int, profilePic:  document.get("profilePic") as! String)
                p.user = actualUserFound
                DatabaseManager.shared.posts.append(p)
                print("Post Creator: \(p.user.userID)")
            }
            else
            {
                print("User does not exist!")
            }
        }
    }
    
    // Updates the arrays that store the posts and
    public func loadFeed()
    {
        print("IN LOAD FEED");
        let collection = db.collection("posts")
        collection.order(by: "likeCount", descending: true).limit(to: 10).getDocuments()
        {
            (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.posts = []
                var uids: [String] = []
                var newPosts: [Post] = []
                // Iterates through all posts in Firebase
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    let p = Post(pid: document.documentID,
                                 text: data["text"] as! String,
                                 media: data["media"] as! String,
                                 user: User(),
                                 likeCount: data["likeCount"] as! Int,
                                 image: data["image"] as? String)
                    //                        self.SetPostsUser(uid: data["uid"] as! String, p: p)
                    //                        self.posts.append(p)
                    uids.append(data["uid"] as! String)
                    newPosts.append(p)
                    print("POST: \(document.documentID) => \(document.data())")
                }
                // Links each post to a post user
                for i in 0..<newPosts.count
                {
                    self.setPostsUser(uid: uids[i], p: newPosts[i])
                }
            }
        }
    }
    
    // May not be needed -- Never called
    public func updatePosts()
    {
        let collection = db.collection("posts");
        for post in posts
        {
            db.collection("posts").document(post.postID).setData(post.dictionary) { err in
                if let err = err {
                    print("Error updating post to db: \(err)")
                } else {
                    print("post successfully updated to db!")
                }
            }
            
            let postDoc = collection.document(post.postID)
            postDoc.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                } else {
                    print("UPDATE POST: Post does not exist", post.postID)
                }
            }
        }
        posts = []
    }
    
    public func addComment(with text: String, post: Post)
    {
        for currPost in posts where currPost.postID == post.postID {
            print("addComment")
            let comment = Post(pid: "comment", text: text,media: "", user: DatabaseManager.shared.sharedUser, likeCount: 0)
            //UserManager.shared.addComment(with: text, post: currPost)
            currPost.addComment(comment)
        }
        NotificationCenter.default.post(name: .NewPosts, object: nil)
    }

    public func addFollowed(username: String) {
        DatabaseManager.shared.sharedUser.addFollowed(userID: username)
    }

    public func removeFollowed(username: String) {
        DatabaseManager.shared.sharedUser.removeFollowed(userID: username)
    }

    public func checkIfFollowed(username: String) -> Bool {
        return DatabaseManager.shared.sharedUser.checkIfFollowed(userID: username)
    }
    
    
    
    /* Comment functionality portion below */
        
        //creates comment from text, ID of commenter, and post on which commented
    public func addComment(content: String, userID: String, postID: String){
        print("Called");
        let vibes = 0
        let id = UUID()
        db.collection("comments").document(id.uuidString).setData([
            "postID": postID,
            "userID": userID,
            "ts": NSDate().timeIntervalSince1970,
            "content": content,
            "vibes": vibes,
            "commentID": id.uuidString
            ]) { err in
                if let err = err {
                    print("Error writing post to db: \(err)")
                } else {
                        print("post successfully written to db!")
                }
            }
         
    }
    
    /* Load all comments of a specific post */
    public func loadComments(postID: String){
        
        db.collection("comments").whereField("postID", isEqualTo: postID).order(by: "vibes", descending: true)
                         .getDocuments() { (querySnapshot, err) in
                             if let err = err {
                                 print("Error getting documents: \(err)")
                             } else {
                                self.comments = []
                                 for document in querySnapshot!.documents {
                                     let data = document.data()
                                     
                                     let currComment = Comment(commentID: data["commentID"] as! String,
                                                               content: data["content"] as! String,
                                                               userID: data["userID"] as! String,
                                                               postID: data["postID"] as! String,
                                                               timeStamp: data["ts"] as! TimeInterval,
                                                               vibes: data["vibes"] as! Int)
                                     
                                     print(currComment)
                                     self.comments.append(currComment)
                                 }
                             }
                     }
        
    }
}


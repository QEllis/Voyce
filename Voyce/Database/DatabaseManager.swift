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
    var myPosts: [Post]
    {
        didSet
        {
            NotificationCenter.default.post(name: .NewPosts, object: nil)
        }
    }
    var index: Int
    
    init()
    {
        sharedUser = User.init()
        db = Firestore.firestore()
        storage = Storage.storage()
        myPosts  = []
        index = 0
        numPosts = 0
        var ref = db.collection("posts").addSnapshotListener() { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
              print("Error fetching documents: \(error!)")
              return
            }
            guard let data = documents.map { $0["name"]! }
            print("Current data: \(data)")
        }
    }
    
    //adjust posts vibes count
    //    public func giveVibe(post: Post)
    //    {
    //        post.vibes += 1;
    //        //    db.collection("posts").document(post.postID).setData(["likeCount":post.likeCount], merge: true);
    //        //
    //        let shardRef = DatabaseManager.shared.db.collection("posts").document(post.postID)
    //        shardRef.updateData(["vibes": FieldValue.increment(Int64(1))])
    //    }
    
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
    
    ///Fix Fix Fix!!!
    // Adds image post to database -- Needs work
    public func addPost(with postType: String, content: String) {
        //        let id = UUID()
        //        let newPost = Post(pid: "0", text: text, media: "", user: sharedUser, likeCount: 0, image: image)
        //        myPosts.insert(newPost, at: 0)
        //        posts.insert(newPost, at: 0)
        //        db.collection("posts").document(id.uuidString).setData([
        //            "uid": sharedUser.userID,
        //            "ts": NSDate().timeIntervalSince1970,
        //            "text": text,
        //            "media": "",
        //            "likeCount": 0,
        //            "comments": ""
        //
        //            let postID: String
        //            let user: User
        //            let userID: String
        //            let date: String
        //            let postType: String
        //            let content: String
        //            var vibes: Int
        //            var caption: String
        //            var comments: [Comment]
        //        ]) { err in
        //            if let err = err {
        //                print("Error writing post to db: \(err)")
        //            } else {
        //                print("image post successfully written to db!")
        //            }
        //        }
    }
    
    // Links a user to a post
    public func setPostsUser(uid: String, p: Post)
    {
        //        let collection = db.collection("users")
        //        collection.document(uid).getDocument() { (document, error) in
        //            if let document = document, document.exists
        //            {
        //                let data = document.data()
        //                let dataDescription = data.map(String.init(describing:)) ?? "nil"
        //                print("GET USER Doc id: \(document.documentID)")
        //                print("GET USER Document data: \(dataDescription)")
        //                let actualUserFound = User(userID: document.documentID, name:  document.get("name") as! String, username:  document.get("username") as! String, totalVibes:  document.get("totalVibes")  as! Int, profilePic:  document.get("profilePic") as! String)
        //                p.user = actualUserFound
        //                DatabaseManager.shared.posts.append(p)
        //                print("Post Creator: \(p.user.userID)")
        //            }
        //            else
        //            {
        //                print("User does not exist!")
        //            }
        //        }
    }
    
    // Updates the arrays that store the posts and
    //    public func loadFeed()
    //    {
    //        print("IN LOAD FEED");
    //        let collection = db.collection("posts")
    //        collection.order(by: "vibes", descending: true).limit(to: 10).getDocuments()
    //        {
    //            (querySnapshot, err) in
    //            if let err = err
    //            {
    //                print("Error getting documents: \(err)")
    //            }
    //            else
    //            {
    //                print("didn't error");
    //                self.posts = []
    //                var uids: [String] = []
    //                var newPosts: [Post] = []
    //                // Iterates through all posts in Firebase
    //                for document in querySnapshot!.documents
    //                {
    //                    print("got document")
    //                    let data = document.data()
    //                    let p = Post(pid: document.documentID,
    //                                 text: data["content"] as! String,
    //                                 media: "",
    //                                 user: User(),
    //                                 likeCount: data["vibes"] as! Int,
    //                                 image: data["content"] as? String)
    //                    //                        self.SetPostsUser(uid: data["uid"] as! String, p: p)
    //                    //                        self.posts.append(p)
    //                    uids.append(data["userID"] as! String)
    //                    newPosts.append(p)
    //                    print("POST: \(document.documentID) => \(document.data())")
    //                }
    //                // Links each post to a post user
    //                for i in 0..<newPosts.count
    //                {
    //                    self.setPostsUser(uid: uids[i], p: newPosts[i])
    //                }
    //            }
    //        }
    //    }
    
    public func loadFeed(view: FeedViewController)
    {
        let collection = db.collection("posts")//.limit(to: 2)//.where post has not been seen
        collection.getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents
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
                    self.posts.append(post)
                    
                    if userID == self.sharedUser.userID {
                        self.myPosts.append(post)
                    }
                }
                
                /// Populate initial cards with posts.
                switch self.index % 2 {
                case 0:
                    view.activeCard.addPost(post: self.posts[self.index])
                    if self.index < self.posts.count - 1 {
                        view.queueCard.addPost(post: self.posts[self.index + 1])
                    }
                    else {
                        view.queueCard.hideCard()
                    }
                case 1:
                    view.queueCard.addPost(post: self.posts[self.index])
                    if self.index < self.posts.count - 1 {
                        view.activeCard.addPost(post: self.posts[self.index + 1])
                    }
                    else {
                        view.activeCard.hideCard()
                    }
                default:
                    print("Error populating the feed.")
                }
                self.incremementIndex()
            }
        }
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
                        print("who is this \(user.username)")
                    }
                }
            }
        }
        return user
    }
    
    func incremementIndex() {
        self.index += 1
    }
    
    /* Comment functionality portion below */
    
    //creates comment from text, ID of commenter, and post on which commented
    public func addComment(content: String, userID: String, postID: String){
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
        //                         .getDocuments() { (querySnapshot, err) in
        //                             if let err = err {
        //                                 print("Error getting documents: \(err)")
        //                             } else {
        //                                self.comments = []
        //                                for document in querySnapshot!.documents {
        //                                     let data = document.data()
        //                                     let currComment = Comment(commentID: data["commentID"] as! String,
        //                                                               content: data["content"] as! String,
        //                                                               userID: data["userID"] as! String,
        //                                                               postID: data["postID"] as! String,
        //                                                               timeStamp: data["ts"] as! TimeInterval,
        //                                                               vibes: data["vibes"] as! Int)
        //
        //                                     print(currComment)
        //                                     self.comments.append(currComment)
        //                                }
        //                             }
        //                     }
    }
    
    /* Helper function that returns true if current user is owner of comment object */
    
    /* If the current signed in user is the one who commented, then the comment object is removed from DB. Otherwise nothing happens */
    public func removeComment(currComment: Comment){
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
        //        let collection = db.collection("users")
        //        collection.order(by: "totalVibes", descending: true).limit(to: 10).getDocuments()
        //        {
        //            (querySnapshot, err) in
        //            if let err = err
        //            {
        //                print("Error getting documents: \(err)")
        //            }
        //            else
        //            {
        //                // Iterates trough all users in the database
        //                for document in querySnapshot!.documents
        //                {
        //                    let user = User(userID: document.documentID, name:  document.get("name") as! String, username:  document.get("username") as! String, totalVibes:  document.get("totalVibes")  as! Int, profilePic:  document.get("profilePic") as! String)
        //                    if user.userID != self.sharedUser.userID
        //                    {
        //                        self.otherUsers.append(user)
        //                    }
        //                }
        //                print("OtherUsers: \(self.otherUsers)")
        //            }
        //        }
    }
}

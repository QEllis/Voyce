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
    var storage: Storage
    var otherUsers: [User]
    var index: Int
    var vibeConversionRate: Double
    var myPosts: [Post]
    var comments: [Comment]
    init()
    {
        sharedUser = User.init()
        db = Firestore.firestore()
        storage = Storage.storage()
        otherUsers = []
        index = 0
        vibeConversionRate = 0.0
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
        setVibeConversionRate()
    }
    
    // Resets data inside the database manager when another user in
    func resetData()
    {
        self.otherUsers = []
        self.index = 0
        self.vibeConversionRate = 0.0
        self.myPosts = []
        self.comments = []
    }
    
    // Gets the vibeconversion rate from the database
    func setVibeConversionRate()
    {
        db.collection("conversion").getDocuments(){ querySnapshot, error in
            if let error = error
            {
                print("Error getting documents: \(error)")
            }
            else
            {
                // Should only loop once
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    self.vibeConversionRate = data["conversionRate"] as! Double
                }
            }
        }
    }
    
    public func loadUser(){
        let collection = db.collection("users")
        let userDoc = collection.document(sharedUser.userID)
        userDoc.getDocument { (document, error) in
            if let document = document, document.exists
            {
                self.sharedUser.loadUserData(document: document)
            }
            else
            {
                userDoc.setData(self.sharedUser.dictionary)
                print("User does not exist yet. New user added to database.",self.sharedUser.userID)
            }
        }
    }
    
    /// Called when the user logs in.
    public func userLogin(u: FirebaseAuth.User){
        sharedUser = User.init(user: u)
        
        //avoid nil
        if(self.sharedUser.username.isEmpty){
            self.sharedUser.username = self.sharedUser.name;
        }

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
    
    // Adds image post to database
    public func addPost(post: Post) {
        let id = UUID()
        myPosts.append(post)
        db.collection("posts").document(id.uuidString).setData([
            "caption": post.caption,
            "content": post.content,
            "date": post.date,
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
        db.collection("posts").document(postID).collection("comments").order(by: "vibes", descending: false)
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
    
    /* If the current signed in user is the one who commented, then the comment object is removed from DB. Otherwise nothing happens */
    public func removeComment(postID: String, commentID: String) {
        print("comment \(commentID)")
        print("post \(postID)")
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
                        if uid != self.sharedUser.userID
                        {
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
    
    public func createPost(contentURL: String, postType: String, caption: String){
        var content = ""
        if(postType == "image"){
            content = contentURL;
        }else if(postType == "text"){
            content = caption;
        }else{
            content = contentURL;
        }
        let post = Post(pid: "", user: self.sharedUser, postType: postType, content: content, vibes: 0, caption:caption)
        self.addPost(post: post)
    }
    
    public func uploadVideo(videoURL: String, caption: String){
        let data = Data()

        let loc = URL(string: videoURL)!
        //let loc = URL(string: "file:///Users/Matt/Library/Developer/CoreSimulator/Devices/DBB95A2E-B5CF-4CB5-92CD-C28291F5C827/data/Containers/Data/PluginKitPlugin/3C5C04F8-98B4-471E-A9E0-02491DC88FC9/tmp/trim.3F44E645-8D06-47FC-A272-909C8ED98E3F.MOV")!;
        let fileName = NSUUID().uuidString + ".mp4"
        let riversRef = Storage.storage().reference().child(fileName)
        
        
        let uploadTask = riversRef.putFile(from: loc, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            print("error occured")
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
            self.createPost(contentURL: downloadURL.absoluteString, postType: "video", caption: caption)
          }
        }
    }
    
    public func uploadImage (image: UIImageView, choice: Int, caption: String){
        var uploadedImageURL: String?
        if let data = image.image!.pngData(){
                let imageName = NSUUID().uuidString
                // Create a reference to the file you want to upload
                let imageRef = Storage.storage().reference().child(imageName)
                // Upload the file to the path
                let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
                  guard let metadata = metadata else {
                    return
                  }
                  // Metadata contains file metadata such as size, content-type.
                  let size = metadata.size
                  imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                    print("Image link: \(downloadURL)")
                    uploadedImageURL = downloadURL.absoluteString
                    //used to check if uploading to database as post or updating image
                    if(choice == 1){
                        self.updateProfileImage(profileURL: uploadedImageURL ?? "")
                    }else if(choice == 2){ //upload image to database
                        self.createPost(contentURL: uploadedImageURL!, postType: "image", caption: caption)
                    }
                  }
            }
        }
    }
    //updates profile image of the user
    public func updateProfileImage(profileURL: String){
        let collection = db.collection("users");
        let userDoc = collection.document(sharedUser.userID)
        self.sharedUser.profilePic = profileURL
        userDoc.getDocument { (document, error) in
            self.sharedUser.profilePic = profileURL
            if let document = document, document.exists{
                //updates content
                self.db.collection("users").document(self.sharedUser.userID).setData([
                    "name": document.get("name"),
                    "profilePic": profileURL,
                    "fundingSource": document.get("fundingSource"),
                    "totalVibes": document.get("totalVibes"),
                    "adVibes": document.get("adVibes"),
                    "earnedVibes": document.get("earnedVibes"),
                    "username": document.get("username")
                ]) { err in
                    //error happened
                    if let err = err {
                        print("Error writing post to db: \(err)")
                    }else{
                        
                    }
                }
            }
        };
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}

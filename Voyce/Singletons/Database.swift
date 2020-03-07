//
//  Database.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/3/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Database
{
    static let shared = Database()
    var db: Firestore!
    
    private init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    //Add user
    
    //Remove user
    
    //Add a new post with an image
    func addPostPic(text: String) {
        db.collection("posts").document().setData([
            "image": "Los Angeles",
            "vibeCount": 0,
            "media": "",
            "text": "",
            "ts": "",
            "uid": ""])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //Add a new post with a video
    func addPostVideo(text: String) {
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //Add a new post with text
    func addPostText(text: String) {
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //Remove post
    
    //Vibe with a post
    func vibe(key: String) -> Bool {
        let postRef = db.collection("posts").document(key)
        return true
    }
}

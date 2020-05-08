
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class User
{
    var userID: String
    var name: String
    var username: String
    var adVibes: Int
    var earnedVibes: Int
    var totalVibes: Int
    var profilePic: String
    var fundingSource: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "username": username,
            "adVibes": adVibes,
            "earnedVibes": earnedVibes,
            "totalVibes": totalVibes,
            "profilePic": profilePic,
            "fundingSource": fundingSource
        ]
    }
    
    init() {
        self.userID = "0"
        self.name = "0"
        self.username = "0"
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = 0
        self.profilePic = ""
        self.fundingSource = ""
    }
    
    init(userID: String, name: String, username: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = 0
        self.earnedVibes = 0
        self.adVibes = 0
        self.profilePic = ""
        self.fundingSource = ""
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = totalVibes
        self.profilePic = ""
        self.fundingSource = ""
    }
    
    init(userID: String, name: String, username: String, adVibes: Int, earnedVibes: Int, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = adVibes
        self.earnedVibes = earnedVibes
        self.totalVibes = totalVibes
        self.profilePic = profilePic
        self.fundingSource = ""
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = totalVibes
        self.profilePic = profilePic
        self.fundingSource = ""
    }
    
    init(user: FirebaseAuth.User) {
        self.userID = user.uid
        self.name = user.displayName!
        self.username = getUserName(name: self.name)
        self.totalVibes = 0
        self.earnedVibes = 0
        self.adVibes = 0
        self.profilePic = ""
        self.fundingSource = ""
   
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.username = document.get("username") as! String
                self.adVibes = document.get("adVibes") as! Int
                self.earnedVibes = document.get("earnedVibes") as! Int
                self.totalVibes = document.get("totalVibes") as! Int
                self.profilePic = document.get("profilePic") as! String
                self.fundingSource = document.get("fundingSource") as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadUserData(document: DocumentSnapshot)
    {
        let data = document.data()
        self.userID = document.documentID
        self.name = data?["name"] as! String
        self.username = data?["username"] as! String
        self.adVibes = data?["adVibes"] as! Int
        self.earnedVibes = data?["earnedVibes"] as! Int
        self.totalVibes = data?["totalVibes"] as! Int
        self.profilePic = data?["profilePic"] as! String
        self.fundingSource = data?["fundingSource"] as! String
    }
    
    func addVibes(adVibes: Int) {
        self.adVibes += adVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["adVibes": FieldValue.increment(Int64(adVibes))])
    }
    
    func addVibes(earnedVibes: Int) {
        self.earnedVibes += earnedVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["earnedVibes": FieldValue.increment(Int64(earnedVibes))])
    }
    
    func addVibes(totalVibes: Int) {
        self.totalVibes += totalVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["totalVibes": FieldValue.increment(Int64(totalVibes))])
    }
    
    func removeAdVibe()
    {
        self.adVibes -= 1
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["adVibes": FieldValue.increment(Int64(-1))])
    }
    
    func removeEarnedVibe() {
        self.earnedVibes -= 1
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["earnedVibes": FieldValue.increment(Int64(-1))])
    }
    
    func hasAdVibes() -> Bool {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.adVibes = document.get("adVibes") as! Int
            } else {
                print("Document does not exist")
            }
        }
        if self.adVibes > 0 {
            return true;
        }
        return false;
    }
    
    func updateEarnedVibes()
    {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        docRef.getDocument
           { (document, error) in
           if let document = document, document.exists
           {
               self.earnedVibes = document.get("earnedVibes") as! Int
           }
           else
           {
               print("Document does not exist")
           }
       }
    }
    
    func updateTotalVibes(onSuccess: @escaping () -> Void)
    {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        docRef.getDocument
           { (document, error) in
           if let document = document, document.exists{
                print(self.totalVibes)
                self.totalVibes = document.get("totalVibes") as! Int
                print(self.totalVibes)
                onSuccess()
            
           }else{
               print("Document does not exist")
           }
       }
    }
    
    // Note: Can't replace inner code with updateEarnedVibes() since it will check
    // self.earnedVibes before function has completed. Async Functions need to be updated
    // by returning future/promise or callback function.
    func hasEarnedVibes() -> Bool
    {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        docRef.getDocument
            { (document, error) in
            if let document = document, document.exists
            {
                self.earnedVibes = document.get("earnedVibes") as! Int
            }
            else
            {
                print("Document does not exist")
            }
        }
        if self.earnedVibes > 0 {
            return true;
        }
        return false;
    }
    
    func changeProfilePic(profilePic: String) {
        self.profilePic = profilePic
        
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["profilePic": profilePic])
    }
    
    // Returns updates the funding source inside the user class
    func updateFundingSource()
    {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists
            {
                self.fundingSource = document.get("fundingSource") as! String
                print("Funding: \(self.fundingSource)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Ruturns true if the user class contains a funding source
    func hasFundingSource() -> Bool
    {
        return self.fundingSource != ""
    }
}

// Returns a default username based on the user's name
// external method because it is called before the object is initialized
func getUserName(name: String) -> String
{
   var userName = ""
   let names = name.split(separator: " ")
   if names.count == 0
   {
       userName = "Nil"
   }
   else if names.count == 1
   {
       userName = name
   }
   else
   {
       let firstName = names[0]
       let firstChar = firstName[firstName.startIndex]
       userName = String(firstChar) + names[1]
   }
   return userName
}

//
//  MyProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

// --- Used for firebase functions below ---
//import Firebase

import Foundation
import UIKit


private let user = DatabaseManager.shared.sharedUser

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPostTableViewCellDelegate
{
    // --- Used for firebase functions below ---
    // lazy var functions = Functions.functions()
    
    // Member Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goodVibesLabel: UILabel!
    var followed:Bool = false

    // Member Functions
    override func viewDidLoad()
    {
        // UserManager.shared.initWithPlaceholderPosts()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPostCell")
        NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
        goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
    }

    override func viewDidAppear(_ animated: Bool)
    {
        loadTextFields()
        tableView.reloadData()
    }

    private func loadTextFields()
    {
        print("Loaded Text Fields")
        print("\(DatabaseManager.shared.sharedUser.totalVibes)")
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
        goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
        print(usernameLabel.text ?? "none")
        print(goodVibesLabel.text ?? "none")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return count of my posts
        return DatabaseManager.shared.myPosts.count
    }
    
    // Requires my MyPostTableViewCellDelegate, which in turn requires the promoteButtonDidPressed function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostTableViewCell
        cell.fillOut(with: DatabaseManager.shared.myPosts[indexPath.row])
        cell.delegate = self
        return cell
    }

    func promoteButtonDidPressed(post: Post)
    {
        
    }

    @objc private func newPosts()
    {
        print("New opsts reload")
        tableView.reloadData()
    }
    
    // ---- Does not compile due to firebase functions installation that is required ----
    // Uses Dwolla API and Firebase Functions to make API Request
    // Transfer funds to user for vibes will be implemented in the future
    @IBAction func transferButtonPressed(_ sender: Any)
    {
//        print("Button Pressed")
//        functions.httpsCallable("addMessage").call(["text": "This is a test"])
//        {(result, error) in
//            // Handles any errors in the communication
//            if let error = error as NSError?
//            {
//                if error.domain == FunctionsErrorDomain
//                {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
//                }
//            }
//            // Handles the responses from the server
//            if let text = (result?.data as? [String: Any])?["text"] as? String
//            {
//                print("This is the output " + text)
//            }
//        }
    }
}

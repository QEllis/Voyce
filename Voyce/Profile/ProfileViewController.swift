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
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPostTableViewCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    // Member Variables
    private let user = DatabaseManager.shared.sharedUser
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var vibesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var followed: Bool = false
    
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
        vibesLabel.text = "Total Vibes: \(user.totalVibes)"
        
        profileImage.image = URLToImg(URL(string: user.profilePic))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageClick)))
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFit
        //profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        //profileImage.clipsToBounds = true
        profileImage?.layer.cornerRadius = (profileImage?.frame.height ?? 40.0)/2.0
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
        vibesLabel.text = "Total Vibes: \(user.totalVibes)"
        print(usernameLabel.text ?? "none")
        print(vibesLabel.text ?? "none")
        print("users'ad vibes are \(DatabaseManager.shared.sharedUser.adVibes)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return count of my posts
        //        return DatabaseManager.shared.myPosts.count
        return 0
    }
    
    // Requires my MyPostTableViewCellDelegate, which in turn requires the promoteButtonDidPressed function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostTableViewCell
        //        cell.fillOut(with: DatabaseManager.shared.myPosts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    @objc private func newPosts()
    {
        print("New opsts reload")
        tableView.reloadData()
    }
    
    func promoteButtonDidPressed(post: Post) {
        
    }
    
    /// Logout current shared user.
    @IBAction func logout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError {
            print ("Error signing out: \(error)")
        }
        
        /// Redirect user back to the root view controller
        let rootVC = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "RootVC")
        view.window?.rootViewController = rootVC
    }
    
    //handles loading images into profile UIView
    @objc func handleImageClick(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    //ImagePickerController for loading the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newProfileImage: UIImage?
        print("Image Upload Clicked")
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            newProfileImage = editedImage
        }else if let original = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            newProfileImage = original
        }
        if let newImage = newProfileImage{
            profileImage.image = newImage
        }
        DatabaseManager.shared.uploadImage(image: profileImage, choice: 1, caption:"")
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newProfileImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            newProfileImage = editedImage
        }else if let original = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            newProfileImage = original
        }
        if let newImage = newProfileImage{
            profileImage.image = newImage
        }

        DatabaseManager.shared.uploadImage(image: profileImage, choice: 1, caption: "")
        dismiss(animated: true, completion: nil)
    }
    //if we exit picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Converts a URL to an image
    func URLToImg(_ url: URL?) -> UIImage?{
        guard let imageURL = url else
        {
            return nil
        }
        let data = try? Data(contentsOf: imageURL)
        return UIImage(data: data!)
    }
}

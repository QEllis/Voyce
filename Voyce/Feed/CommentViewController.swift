//
//  CommentViewController.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/22/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import FirebaseFirestoreSwift

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    @IBOutlet var postText: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postVideo: UIView!
    @IBOutlet var videoPausedView: UIView!
        
    @IBOutlet var commentFeed: UITableView!
    
    @IBOutlet var commentView: UIView!
    @IBOutlet var commentText: UITextField!
    @IBOutlet var commentViewBottom: NSLayoutConstraint!
    @IBOutlet var commentButton: UIButton!
    
    var post: Post!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.commentText.delegate = self
        
        commentFeed.delegate = self
        commentFeed.dataSource = self

        loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentFeed.reloadData()
    }
    
    private func loadContent() {
        switch post.postType {
        case "text":
            postText.isHidden = false
            postText.text = post.content;
        case "image":
            postImage.isHidden = false
            let url = URL(string: post.content)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                self.postImage.image = UIImage(data: data!)
            }
        case "video":
            postVideo.isHidden = false
            let url = URL(string: post.content)
            if url != nil {
                let player = AVPlayer(url: url!)
                let playerFrame = CGRect(x: 0, y: 0, width: postVideo.frame.width, height: postVideo.frame.height)
                let videoPlayerView = VideoPlayerView(frame: playerFrame)
                videoPlayerView.player = player
                postVideo.addSubview(videoPlayerView)
                player.play()
            }
        default:
            print("Error: Unknown Post Type for \(post.postID)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.shared.comments.count + (post.caption != "" ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = (indexPath.row == 0 && post.caption != "") ? "CaptionCell" : "CommentCell"
        
        guard let cell = commentFeed.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommentCell else {
            fatalError("The dequeued cell is not an instance of CommentCell.")
        }
        let comment = DatabaseManager.shared.comments[safe: indexPath.row - 1]
        
        if indexPath.row == 0 && post.caption != "" {
            getCommenterInfo(cell: cell, userID: post.userID)
        } else {
            getCommenterInfo(cell: cell, userID: comment!.userID)
        }
        
        cell.comment.text = (indexPath.row == 0 && post.caption != "") ? post.caption : comment!.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }

        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
        }
        share.backgroundColor = UIColor(named: "Gray")

        return [delete, share]
    }
    
    private func getCommenterInfo(cell: CommentCell, userID: String) {
        DatabaseManager.shared.db.collection("users").document(userID).getDocument() { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let profilePic = data!["profilePic"] as! String
                let username = data!["username"] as! String
                
                let profilePicURL = URL(string: profilePic)
                cell.profilePic.image = self.URLToImg(profilePicURL)
                self.circularImg(imageView: cell.profilePic)
                cell.username.text = username
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func URLToImg(_ url: URL?) -> UIImage?
    {
        guard let imageURL = url else
        {
            return nil
        }
        let data = try? Data(contentsOf: imageURL)
        return UIImage(data: data!)
    }
    
    /// Changes the shape of each profile image into a circle.
    func circularImg(imageView: UIImageView?)
    {
        imageView?.layer.cornerRadius = (imageView?.frame.height ?? 50.0) / 2.0
    }
    
    /// Pause/Play video when postVideo is pressed.
    @IBAction func videoPressed(_ sender: Any) {
        for subview in postVideo.subviews {
            let view = subview as! VideoPlayerView
            view.player?.pause()
            videoPausedView.isHidden = false
        }
    }
    
    /// Play video when postVideo is pressed.
    @IBAction func videoPausedPressed(_ sender: UITapGestureRecognizer) {
        for subview in postVideo.subviews {
            let view = subview as! VideoPlayerView
            view.player?.play()
            videoPausedView.isHidden = true
        }
    }
    
    ///Move the commentText and toggle commentButton with keyboard.
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.commentViewBottom.constant = 0.0
                self.commentButton.isHidden = true
            } else {
                self.commentViewBottom.constant = (endFrame?.size.height ?? 0.0) - 40
                self.commentButton.isHidden = false
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    /// Dismiss the keybaord.
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Post a comment with commentButton.
    @IBAction func commentButtonClicked(_ sender: UIButton) {
        postComment(comment: commentText.text!)
    }
    
    /// Post a comment with return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postComment(comment: commentText.text!)
        return false
    }
    
    /// Post a comment
    func postComment(comment: String) {
        if commentText.text != "" {
            DatabaseManager.shared.addComment(content: comment, userID: DatabaseManager.shared.sharedUser.userID, postID: post.postID)
            commentText.text = ""
        }
        DatabaseManager.shared.loadComments(postID: post.postID)
        dismissKeyboard()
    }
}

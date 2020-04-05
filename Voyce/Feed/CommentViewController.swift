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

class CommentViewController: UIViewController
{
    @IBOutlet var postText: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postVideo: UIView!
    @IBOutlet var videoPausedView: UIView!
    
    @IBOutlet var commentFeed: UITableView!
    
    var post: Post!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "exitComments"), object: nil)
        loadContent()
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
}
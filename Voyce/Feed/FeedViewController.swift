//
//  FeedViewController.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 2/1/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class FeedViewController: UIViewController
{
    @IBOutlet var adVibes: UILabel!
    @IBOutlet var noMorePosts: UIStackView!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        adVibes.text = String(DatabaseManager.shared.sharedUser.adVibes) /// Display current adVibes.
        addCard(first: true) /// Add first card.
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DatabaseManager.shared.db.collection("users").document(DatabaseManager.shared.sharedUser.userID).addSnapshotListener() { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            self.adVibes.text = String(document.data()?["adVibes"] as! Int)
        }
    }
    
    func addCard(first: Bool) {
        let card = Card(frame: CGRect(x: 0, y: 0, width: view.frame.width - (first ? 20 : 40), height: view.frame.height - (first ? 210 : 230)))
        card.center = view.center
        card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCard(_:))))
        card.loadPost(feed: self, first: first)
    }
    
    /// Swipable functionality for the  active card.
    @objc func panCard(_ sender: UIPanGestureRecognizer)
    {
        /// Move the card freely.
        let card = sender.view! as! Card
        let point = sender.translation(in: view)
        translateCard(card: card, point: point)
                
        /// Swipe action has ended.
        if sender.state == UIGestureRecognizer.State.ended {
            /// Remove the active card from deck.
            if abs(card.center.x - (view.frame.width / 2)) > 100 || abs(card.center.y - (view.frame.height / 2)) > 125 {
                let offScreenX = card.center.x < view.center.x ? -500 : view.frame.width + 500
                let offScreenY = card.center.y < view.center.y ? -500 : view.frame.height + 500
                UIView.animate(withDuration: 0.25, animations: {
                    card.center = CGPoint(x: offScreenX, y: offScreenY)
                    card.alpha = 0 })
                
                /// Remove card and load a new one.
                //  DatabaseManager.shared.postSeen(postID: card.post!.postID, userID: card.post!.userID)
                card.removeFromSuperview()
                addCard(first: false)
                
                /// Play video of top card (if exists and has postType: video).
                let cards = view.subviews.compactMap{$0 as? Card}
                if let newCard = cards[safe: cards.count - 1] {
                    newCard.playVideo()
                }
            }
                /// Reset the active card if the swipe is premature.
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = self.view.center
                    card.alpha = 1
                    card.transform = CGAffineTransform(rotationAngle: 0)
                    
                    let cards = self.view.subviews.compactMap{$0 as? Card}
                    if let newCard = cards[safe: cards.count - 1] {
                        newCard.center = self.view.center
                        newCard.frame.size.width = self.view.frame.width - 20
                        newCard.frame.size.height = self.view.frame.height - 210
                    }
                })
            }
        }
    }
    
    /// Move card to indicated point.
    private func translateCard(card: Card, point: CGPoint) {
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        /// Set transparency of the card.
        let xFromCenter = card.center.x - view.center.x
        let yFromCenter = card.center.y - view.center.y
        let distFromCenter = sqrt(xFromCenter * xFromCenter + yFromCenter * yFromCenter)
        card.alpha = 1 - (abs(distFromCenter) / view.frame.height)
        
        /// Angle the card with movement.
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 1.02))
        
        /// Bring the queued card to the front visually.
        growCard(dist: distFromCenter)
    }
    
    /// Adjust size of queued card.
    private func growCard(dist: CGFloat) {
        let cards = view.subviews.compactMap {$0 as? Card}
        let index = cards.count - 2
        
        if let card = cards[safe: index] {
            let delta = 20 * (1 - ((dist < 250 ? dist : 250) / 250))
            
            card.frame.size.width = view.frame.width - (20 + delta)
            card.frame.size.height = view.frame.height - (210 + delta)
            card.center = view.center
        }
    }
    
    /// Reload feed upon tapping No More Posts
       @IBAction func reloadFeed(_ sender: UITapGestureRecognizer) {
        DatabaseManager.shared.index = 0
        addCard(first: true)
    }
    
    /// Send the active cards data to CommentVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CommentViewController
        {
            let vc = segue.destination as? CommentViewController
//            switch counter % 2 {
//            case 0:
//                if activeCard.post?.postType == "video" {
//                    activeCard.pauseVideo()
//                }
//                vc?.post = self.activeCard.post
//            case 1:
//                if queueCard.post?.postType == "video" {
//                    queueCard.pauseVideo()
//                }
//                vc?.post = self.queueCard.post
//            default: print("Error: counter is an invalid integer.")
//            }
        }
    }
    
    //    /// Play video when exiting the comments.
    //    @objc func exitComments() {
    //        switch counter % 2 {
    //        case 0:
    //            if activeCard.post?.postType == "video" {
    //                for subview in activeCard.postVideo.subviews {
    //                    let view = subview as! VideoPlayerView
    //                    view.player?.play()
    //                    activeCard.videoPausedView.isHidden = true
    //                }
    //            }
    //        case 1:
    //            if queueCard.post?.postType == "video" {
    //                for subview in queueCard.postVideo.subviews {
    //                    let view = subview as! VideoPlayerView
    //                    view.player?.play()
    //                    queueCard.videoPausedView.isHidden = true
    //                }
    //            }
    //        default: print("Error: counter is an invalid integer.")
    //        }
    //    }
}

//extension Array {
//    subscript(safe index: Index) -> Element? {
//        let isValidIndex = index >= 0 && index < count
//        return isValidIndex ? self[index] : nil
//    }
//}

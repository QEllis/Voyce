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
    @IBOutlet weak var activeCard: Card!
    @IBOutlet weak var queueCard: Card!
    @IBOutlet var adVibes: UILabel!
    
    @IBOutlet var noMorePosts: UIStackView!
    
    /// Keeps track of how many cards have been swiped.
    var counter: Int = 0
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        adVibes.text = String(DatabaseManager.shared.sharedUser.adVibes)
        //        NotificationCenter.default.addObserver(self, selector: #selector(exitComments), name: NSNotification.Name(rawValue: "exitComments"), object: nil)

        /// Load first active card.
        DatabaseManager.shared.loadFeed(view: self, firstCard: true)

        /// Load first queued card.
        DatabaseManager.shared.loadFeed(view: self, firstCard: false)
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
    
    /// Swipable functionality for the  active card.
    @IBAction func panCard(_ sender: UIPanGestureRecognizer)
    {
        /// Move the card freely.
        let card = sender.view! as! Card
        let point = sender.translation(in: view)
        translateCard(card: card, point: point)
        
        /// Bring the queued card to the front visually with constraints.
        changeConstraints(cardTop: false, sidesAndTop: 10, bottom: 15)
        
        /// Swipe action has ended.
        if sender.state == UIGestureRecognizer.State.ended {
            /// Remove the active card from deck.
            if abs(card.center.x - (view.frame.width / 2)) > 100 || abs(card.center.y - (view.frame.height / 2)) > 125 {
                let offScreenX = card.center.x < view.center.x ? -500 : view.frame.width + 500
                let offScreenY = card.center.y < view.center.y ? -500 : view.frame.height + 500
                UIView.animate(withDuration: 0.25, animations: {
                    card.center = CGPoint(x: offScreenX, y: offScreenY)
                    card.alpha = 0 })
                DatabaseManager.shared.postSeen(postID: card.post!.postID, userID: card.post!.userID)
                
                /// Send the active card to the back and remove content.
                card.removePost()
                view.sendSubviewToBack(card)
                view.sendSubviewToBack(noMorePosts)
                
                /// Load the next queued card.
                card.center = self.view.center
                card.alpha = 1
                card.transform = CGAffineTransform(rotationAngle: 0)
                DatabaseManager.shared.loadFeed(view: self, firstCard: false)
                
                switch counter % 2 {
                case 0:
                        queueCard.playVideo()
                case 1:
                        activeCard.playVideo()
                default: print("Error: counter is an invalid integer.")

                }
                
                /// Set the size of the old active card constraints to those of a queued card.
                changeConstraints(cardTop: true, sidesAndTop: 20, bottom: 25)
            }
                /// Reset the active card if the swipe is premature.
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = self.view.center
                    card.alpha = 1
                    card.transform = CGAffineTransform(rotationAngle: 0)
                })
                
                /// Reset the queued card to its initial constraints.
                changeConstraints(cardTop: false, sidesAndTop: 20, bottom: 25)
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
    }
    
    /// Adjust constraints of card.
    private func changeConstraints(cardTop: Bool, sidesAndTop: Int, bottom: Int) {
        switch (counter + Int(truncating: NSNumber(value: cardTop))) % 2 {
               case 0:
                   for constraint in view.constraints {
                       switch constraint.identifier {
                       case "queueTop":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(sidesAndTop)
                           }
                       case "queueLeft", "queueRight":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(sidesAndTop)
                           }
                       case "queueBottom":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(bottom)
                           }
                       case .none:
                           break
                       case .some(_):
                           break
                       }
                   }
               case 1:
                   for constraint in view.constraints {
                       switch constraint.identifier {
                       case "activeTop":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(sidesAndTop)
                           }
                       case "activeLeft", "activeRight":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(sidesAndTop)
                           }
                       case "activeBottom":
                           UIView.animate(withDuration: 5) {
                            constraint.constant = CGFloat(bottom)
                           }
                       case .none:
                           break
                       case .some(_):
                           break
                       }
                   }
               default:
                   print("Error: counter is an invalid integer.")
               }
    }
    
    /// Send the active cards data to CommentVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CommentViewController
        {
            let vc = segue.destination as? CommentViewController
            switch counter % 2 {
            case 0:
                if activeCard.post?.postType == "video" {
                    activeCard.pauseVideo()
                }
                vc?.post = self.activeCard.post
            case 1:
                if queueCard.post?.postType == "video" {
                    queueCard.pauseVideo()
                }
                vc?.post = self.queueCard.post
            default: print("Error: counter is an invalid integer.")
            }
        }
    }
    
    /// Reload feed upon tapping No More Posts
    @IBAction func reloadFeed(_ sender: UITapGestureRecognizer) {
        DatabaseManager.shared.reloadFeed(view: self)
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

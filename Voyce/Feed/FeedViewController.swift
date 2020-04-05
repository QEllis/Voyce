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
    @IBOutlet weak var adVibes: UITextView!
    
    /// Keeps track of how many cards have been swiped.
    var counter: Int = 0
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.loadFeed(view: self)
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Swipable functionality for the  active card.
    @IBAction func panCard(_ sender: UIPanGestureRecognizer)
    {
        /// Move the card freely.
        let activeCard = sender.view!
        let point = sender.translation(in: view)
        activeCard.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        /// Set transparency of the card.
        let xFromCenter = activeCard.center.x - view.center.x
        let yFromCenter = activeCard.center.y - view.center.y
        let distFromCenter = sqrt(xFromCenter * xFromCenter + yFromCenter * yFromCenter)
        activeCard.alpha = 1 - (abs(distFromCenter) / view.frame.height)
        
        /// Angle the card with movement.
        activeCard.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 1.02))
        
        /// Bring the queued card to the front visually with constraints.
        switch counter % 2 {
        case 0:
            for constraint in view.constraints {
                switch constraint.identifier {
                case "queueTop":
                    UIView.animate(withDuration: 5) {
                        constraint.constant = 10
                    }
                case "queueLeft", "queueRight":
                    UIView.animate(withDuration: 5) {
                        constraint.constant = 10
                    }
                case "queueBottom":
                    UIView.animate(withDuration: 5) {
                        constraint.constant = 15
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
                        constraint.constant = 10
                    }
                case "activeLeft", "activeRight":
                    UIView.animate(withDuration: 5) {
                        constraint.constant = 10
                    }
                case "activeBottom":
                    UIView.animate(withDuration: 5) {
                        constraint.constant = 15
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
        
        /// Swipe action has ended.
        if sender.state == UIGestureRecognizer.State.ended {
            /// Remove the active card from deck.
            if abs(activeCard.center.x - (view.frame.width / 2)) > 100 || abs(activeCard.center.y - (view.frame.height / 2)) > 125 {
                let offScreenX = activeCard.center.x < view.center.x ? -500 : view.frame.width + 500
                let offScreenY = activeCard.center.y < view.center.y ? -500 : view.frame.height + 500
                UIView.animate(withDuration: 0.25, animations: {
                    activeCard.center = CGPoint(x: offScreenX, y: offScreenY)
                    activeCard.alpha = 0 })
                
                /// Send the active card to the back and the queued card to the front.
                if counter % 2 == 0 {
                    view.sendSubviewToBack(self.activeCard)
                    view.bringSubviewToFront(self.queueCard)
                } else {
                    view.sendSubviewToBack(self.queueCard)
                    view.bringSubviewToFront(self.activeCard)
                }
                
                /// Load the next card.
                activeCard.center = self.view.center
                activeCard.alpha = 1
                activeCard.transform = CGAffineTransform(rotationAngle: 0)

                activeCard.isHidden = true
                
                DatabaseManager.shared.loadFeed(view: self)
                
                
                /// Set the size of the old active card constraints to those of a queued card.
                switch counter % 2 {
                case 0:
                    for constraint in view.constraints {
                        switch constraint.identifier {
                        case "activeTop":
                             constraint.constant = 20
                        case "activeLeft", "activeRight":
                            constraint.constant = 20
                        case "activeBottom":
                            constraint.constant = 25
                        case .none:
                            break
                        case .some(_):
                            break
                        }
                    }
                case 1:
                    for constraint in view.constraints {
                        switch constraint.identifier {
                        case "queueTop":
                            constraint.constant = 20
                        case "queueLeft", "queueRight":
                            constraint.constant = 20
                        case "queueBottom":
                            constraint.constant = 25
                        case .none:
                            break
                        case .some(_):
                            break
                        }
                    }
                default:
                    print("Error: counter is an invalid integer.")
                }
                counter += 1
            }
                /// Reset the active card if the swipe is premature.
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    activeCard.center = self.view.center
                    activeCard.alpha = 1
                    activeCard.transform = CGAffineTransform(rotationAngle: 0)
                })
                
                /// Reset the queued card to its initial constraints.
                switch counter % 2 {
                case 0:
                    for constraint in view.constraints {
                        switch constraint.identifier {
                        case "queueTop":
                            UIView.animate(withDuration: 5) {
                                constraint.constant = 20
                            }
                        case "queueLeft", "queueRight":
                            UIView.animate(withDuration: 5) {
                                constraint.constant = 20
                            }
                        case "queueBottom":
                            UIView.animate(withDuration: 5) {
                                constraint.constant = 25
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
                                constraint.constant = 20
                            }
                        case "activeLeft", "activeRight":
                            UIView.animate(withDuration: 5) {
                                constraint.constant = 20
                            }
                        case "activeBottom":
                            UIView.animate(withDuration: 5) {
                                constraint.constant = 25
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
        }
    }
    
    /// Send the active cards data to CommentVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CommentViewController
        {
            let vc = segue.destination as? CommentViewController
            switch counter % 2 {
            case 0: vc?.post = self.activeCard.post
            case 1: vc?.post = self.queueCard.post
            default: print("Error: counter is an invalid integer.")
            }
        }
    }
}

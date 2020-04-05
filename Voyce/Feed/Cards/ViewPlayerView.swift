//
//  ViewPlayerView.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 4/5/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class VideoPlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

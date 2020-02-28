//
//  PlayerView.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/28.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class KekPlayerLayer: AVPlayerLayer {
    
    @objc func setPlaceholderContentLayerDuringPIPMode(_ contentLayer: CALayer) {
        print()
    }
    
}

class PlayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

}

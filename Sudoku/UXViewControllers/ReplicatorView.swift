//
//  ReplicatorView.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/15/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
// https://www.swiftbysundell.com/posts/ca-gems-using-replicator-layers-in-swift

import UIKit

class ReplicatorView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // programmatically setting frame due to seemingly unpredictable values, despite autolayouts
        layer.frame.size = UIScreen.main.bounds.size
        if layer.frame.size.height < layer.frame.size.width { // landscape
            layer.frame.size.width = layer.frame.size.height
        } else { // portrait
            layer.frame.size.height = layer.frame.size.width
        }
        let dimension = layer.frame.size.width / 9
        let delay = TimeInterval(0.1)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.95
        animation.toValue = 0.5
        
        let fade = CABasicAnimation(keyPath: "backgroundColor")
        fade.fromValue = Style.highlightBGColor.cgColor
        fade.toValue = Style.permanentTextColor.cgColor
        
        let group = CAAnimationGroup()
        group.animations = [animation, fade]
        group.duration = 5
        group.autoreverses = true
        group.repeatCount = .infinity
        
        let imageLayer = CALayer()
        imageLayer.cornerRadius = 5.0
        imageLayer.borderColor = Style.permanentTextColor.cgColor
        imageLayer.borderWidth = 1
        imageLayer.frame.size = CGSize(width: dimension, height: dimension)
        imageLayer.add(group, forKey: nil)
        
        let rowLayer = CAReplicatorLayer()
        rowLayer.frame.size = frame.size
        rowLayer.instanceCount = 9
        rowLayer.instanceTransform = CATransform3DMakeTranslation(dimension, 0, 0)
        rowLayer.instanceDelay = delay
        
        let rootLayer = CAReplicatorLayer()
        rootLayer.frame.size = frame.size
        rootLayer.masksToBounds = true
        rootLayer.instanceCount = 9
        rootLayer.instanceTransform = CATransform3DMakeTranslation(0, dimension, 0)
        rootLayer.instanceDelay = delay
    
        rowLayer.addSublayer(imageLayer)
        rootLayer.addSublayer(rowLayer)
        layer.addSublayer(rootLayer)
    }
}

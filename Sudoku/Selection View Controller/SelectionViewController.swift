//
//  SelectionViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/13/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
// https://www.swiftbysundell.com/posts/ca-gems-using-replicator-layers-in-swift

import UIKit

class SelectionViewController: StyleViewController {

    @IBOutlet weak var replicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(returnToGame))
        swipeGesture.direction = .left
        self.view.addGestureRecognizer(swipeGesture)
        
        let dimension = (replicatorView.frame.size.width / 9)
        let delay = TimeInterval(0.1)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.95
        animation.toValue = 0.5
        
        let fade = CABasicAnimation(keyPath: "backgroundColor")
        fade.fromValue = Style.notesTextColor.cgColor
        fade.toValue = Style.solutionTextColor.cgColor
        
        let group = CAAnimationGroup()
        group.animations = [animation, fade]
        group.duration = 5
        group.autoreverses = true
        group.repeatCount = .infinity
        
        let imageLayer = CALayer()
        imageLayer.cornerRadius = 5.0
        imageLayer.backgroundColor = Style.notesTextColor.cgColor
        imageLayer.borderColor = Style.permanentTextColor.cgColor
        imageLayer.borderWidth = 1
        imageLayer.frame.size = CGSize(width: dimension, height: dimension)
        imageLayer.add(group, forKey: nil)
        
        let rowLayer = CAReplicatorLayer()
        rowLayer.instanceCount = 9
        rowLayer.instanceTransform = CATransform3DMakeTranslation(dimension, 0, 0)
        rowLayer.instanceDelay = delay
        
        let rootLayer = CAReplicatorLayer()
        rootLayer.frame = replicatorView.frame
        rootLayer.masksToBounds = true
        rootLayer.instanceCount = 9
        rootLayer.instanceTransform = CATransform3DMakeTranslation(0, dimension, 0)
        rootLayer.instanceDelay = delay
        
        rowLayer.addSublayer(imageLayer)
        rootLayer.addSublayer(rowLayer)
        replicatorView.layer.addSublayer(rootLayer)
    }

    @objc func returnToGame(){
        view.removeFromSuperview()
        removeFromParentViewController()
    }


}

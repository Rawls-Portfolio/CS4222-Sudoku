//
//  StyleViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/13/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
// https://stackoverflow.com/questions/40262481/uiview-frame-not-updating-after-orientation-change

import UIKit

class StyleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        
        let proxyButton = UIButton.appearance()
        proxyButton.tintColor = Style.permanentTextColor
        let proxyLabel = NotesLabel.appearance()
        proxyLabel.textColor = Style.notesTextColor
    }

    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [Style.solutionTextColor.cgColor, Style.conflictBGColor.cgColor, Style.normalBGColor.cgColor, Style.highlightBGColor.cgColor, Style.notesTextColor.cgColor]
        gradient.locations = [0.5, 0.8, 0.9, 0.95, 0.98]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            let orientation = UIApplication.shared.statusBarOrientation
            switch orientation {
            case .portrait:
                print("Portrait")
            case .landscapeLeft,.landscapeRight :
                print("Landscape")
            default:
                print("Anything But Portrait")
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.view.layer.sublayers?.forEach { (layer) in
                if layer is CAGradientLayer{
                    layer.removeFromSuperlayer()
                    self.addGradient()
                }
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

class NotesLabel: UILabel {}

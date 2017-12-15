//
//  StyleViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/13/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class StyleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [Style.solutionTextColor.cgColor, Style.conflictBGColor.cgColor, Style.normalBGColor.cgColor, Style.highlightBGColor.cgColor, Style.notesTextColor.cgColor]
        gradient.locations = [0.5, 0.8, 0.9, 0.95, 0.98]
        view.layer.insertSublayer(gradient, at: 0)
        
        let proxyButton = UIButton.appearance()
        proxyButton.tintColor = Style.permanentTextColor
        let proxyLabel = NotesLabel.appearance()
        proxyLabel.textColor = Style.notesTextColor
    }

}

class NotesLabel: UILabel {}

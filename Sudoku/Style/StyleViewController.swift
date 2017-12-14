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
        view.backgroundColor = Style.background
        
        let proxyButton = UIButton.appearance()
        proxyButton.tintColor = Style.permanentTextColor
        
        let proxyLabel = NotesLabel.appearance()
        proxyLabel.textColor = Style.notesTextColor
    }

}

class NotesLabel: UILabel {}

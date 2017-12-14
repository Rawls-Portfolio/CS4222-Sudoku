//
//  MenuView.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/29/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: class {
    func displayNumberSelection()
    func displayNewGameMenu()
    func setActive(value: Value)
    func highlightPosition(_ position: Position)
    func highlightActive()
    func toggleMode()
}

class MenuView: UIView {
    // MARK: - Properties
    weak var delegate: MenuViewDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    func prepareButtons(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(highlightNumbers))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(showNumberSelection))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showNumberSelection))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        numberButton.addGestureRecognizer(singleTapGesture)
        numberButton.addGestureRecognizer(doubleTapGesture)
        numberButton.addGestureRecognizer(longPressGesture)
        
        modeButton.setTitle("", for: .normal)
        numberButton.setTitle("", for: .normal)
        newGameButton.setTitle("", for: .normal)
        newGameButton.setImage(#imageLiteral(resourceName: "NewGame"), for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction func modeButtonPressed(_ sender: UIButton) {
        delegate?.toggleMode()
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        delegate?.displayNewGameMenu()
    }
    
    // MARK: - Number Button Gesture Recognition Methods
    @objc func highlightNumbers(gesture: UIGestureRecognizer){
        delegate?.highlightActive()
    }

    @objc func showNumberSelection(gesture: UIGestureRecognizer){
        if gesture.state != .ended {
            return
        }
        
        delegate?.displayNumberSelection()
    }
}

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
    func setActive(value: Value)
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
    }
    // MARK: - IBActions
    // TODO: toggle solution or notes view currently active for user input
    @IBAction func modeButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    // MARK: - Number Button Gesture Recognition Methods
    // TODO: menu item will display currently selected number.
    // TODO: When tapped, all cells containing this value as solution will be highlighted.
    @objc func highlightNumbers(gesture: UIGestureRecognizer){
        print(#function)
    }
    // TODO: A long press or double tap will display a pop up menu allowing the user to select a different number
    // new game (pop up with level selection/restart)

    @objc func showNumberSelection(gesture: UIGestureRecognizer){
        if gesture.state != .ended {
            return
        }
        print(#function)
        
        delegate?.displayNumberSelection()
    }
}

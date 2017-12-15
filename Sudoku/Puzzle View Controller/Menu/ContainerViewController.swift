//
//  NumberSelectionViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/29/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    // MARK: - Properties
    weak var delegate : MenuViewDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var newGameMenu: UIView!
    @IBOutlet weak var cellOptionsMenu: UIView!
    
    // MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Style.applyOverlayStyle(view.layer)
        Style.applyMenuStyle(newGameMenu)
        Style.applyMenuStyle(cellOptionsMenu)
        
        prepareLabels()
    }
    
    // MARK: - Gesture Recognition Functions
    func prepareLabels(){
        labels.forEach{(label) in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            tapGesture.numberOfTapsRequired = 1
            label.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        delegate?.clearBoard()
    }

    @IBAction func newGamePressed(_ sender: UIButton) {
        delegate?.returnToSelection()
    }
    
    @IBAction func closeMenuPressed(_ sender: UIButton) {
        delegate?.closeMenu()
    }
    
    @IBAction func clearContentsPressed(_ sender: UIButton) {
        delegate?.clearSelectedCell()
    }
    
    @IBAction func makePermanentPressed(_ sender: UIButton) {
        delegate?.setPermanentState()
    }
    
    @IBAction func getHintPressed(_ sender: UIButton) {
        delegate?.showSelectedHint()
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        delegate?.showHelp()
    }
    
    @objc func labelTapped(gesture: UIGestureRecognizer){
        guard let label = gesture.view as? UILabel, let value = Value(rawValue: label.text!) else {
            print("label identification failed")
            return
        }
        delegate?.setActive(value: value)
        
    }
}

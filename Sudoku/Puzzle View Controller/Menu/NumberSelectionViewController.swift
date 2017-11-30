//
//  NumberSelectionViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/29/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class NumberSelectionViewController: UIViewController {
    // MARK: - Properties
    weak var delegate : MenuViewDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet var labels: [UILabel]!
    
    // MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 2
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
    
    // TODO: set active value
    @objc func labelTapped(gesture: UIGestureRecognizer){
        guard let label = gesture.view as? UILabel, let value = Value(rawValue: label.text!) else {
            print("label identification failed")
            return
        }
        print("\(value) \(#function)")
        delegate?.setActive(value: value)
        
    }
}

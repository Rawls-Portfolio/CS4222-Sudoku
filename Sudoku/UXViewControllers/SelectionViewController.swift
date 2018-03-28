//
//  SelectionViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/13/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.


import UIKit

class SelectionViewController: StyleViewController {
    // MARK: - Properties
    let pickerData: [Difficulty] = [.easy, .medium, .hard, .expert]
    var selection = Difficulty.easy

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // MARK: - Methods
    @IBAction func startGamePressed(_ sender: UIButton) {
        print("target difficulty: \(selection.targetScore)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let puzzleView = storyboard.instantiateViewController(withIdentifier: "Game") as? PuzzleViewController else { return }
        puzzleView.model = PuzzleModel(targetScore: selection.targetScore)
        puzzleView.willMove(toParentViewController: self)
        addChildViewController(puzzleView)
        view.addSubview(puzzleView.view)
        puzzleView.didMove(toParentViewController: self)
    }

    func setTitle() {
        titleLabel.textColor = Style.notesTextColor
    }
}

extension SelectionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          selection = pickerData[row]
    }
}


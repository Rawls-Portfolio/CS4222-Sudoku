//
//  PuzzleViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/23/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.

import UIKit

class PuzzleViewController: UIViewController {

    // MARK: - Properties
    var model: PuzzleModel!
    
    // MARK: - IBOutlets
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    @IBOutlet weak var menu: MenuView!
    @IBOutlet weak var numberSelectionPlaceholder: UIView!
    
    //MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        model = PuzzleModel(targetScore: 170)
        
        preparePuzzleCollectionView()
        
        menu.delegate = self
        menu.prepareButtons()
    
        numberSelectionPlaceholder.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        if let numberSelection = segue.destination as? NumberSelectionViewController {
            numberSelection.delegate = self
        }
    }
    
    func highlight(for position: Position){
        // TODO: change view only, not the model
        reloadCells(from: position)
    }

    func transition(to mode: Mode){
        // TODO: from view to view
    }
    
    // MARK: - Gesture Recognition Functions
    func preparePuzzleCollectionView() {
        puzzleCollectionView.dataSource = self
        let sideLength = view.frame.size.width - 20
        let frame = CGRect(x: 10, y: 40.0 , width: sideLength , height: sideLength)
        puzzleCollectionView.frame = frame
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellPressed))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        puzzleCollectionView.addGestureRecognizer(singleTapGesture)
        puzzleCollectionView.addGestureRecognizer(doubleTapGesture)
        puzzleCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func cellTapped(gesture: UITapGestureRecognizer){
        let point = gesture.location(in: puzzleCollectionView)
        guard let position = getCellPosition(atPoint: point) else {
            print("\(#function) failed")
            return
        }
        
        var solution: Value?
        switch(gesture.numberOfTapsRequired){
        case 1:
            solution = model.active
            highlight(for: position)
        case 2:
            solution = model.getNoteValue(for: position.toIndex)
        
        default: print("unknown gesture")
        }
        
        if let value = solution {
            model.setSolution(of: value, for: position.toIndex) { (success) in
                if success {
                    transition(to: .solution)
                }
            }
        }
        reloadCells(from: position)
    }

    
    // TODO: long press on a selected cell will display an animated pop-up menu.
     @objc func cellPressed(gesture: UITapGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        guard let position = getCellPosition(atPoint: gesture.location(in: puzzleCollectionView)) else {
            print("\(#function) failed")
            return
        }
        
        /* TODO:
         execute one of these functions in a completion closure
         func clearSelected() {
         
         }
         
         func setPermanentState() {
            // if solution is set
         }
         
         func selectedHint() {
         
         }
         */
    }
    
    func getCellPosition(atPoint point: CGPoint) -> Position? {
        guard let selectedIndexPath: IndexPath = puzzleCollectionView.indexPathForItem(at: point),
            let cell = puzzleCollectionView.cellForItem(at: selectedIndexPath) as? PuzzleViewCell,
            let position = cell.position
            else {
                return nil
        }
        return position
    }
    
    func reloadCell(atPoint point: CGPoint){
        guard let selectedIndexPath: IndexPath = puzzleCollectionView.indexPathForItem(at: point) else {
            return
        }
        puzzleCollectionView.reloadItems(at: [selectedIndexPath])
    }
    
    func reloadCells(from position: Position){
        let indexPaths = [IndexPath]()
        //TODO: how to obtain index path for item based on position? or save indexpath in Cell?
        puzzleCollectionView.reloadItems(at: indexPaths)
    }
}

// MARK: - Collection View Data Source Methods
extension PuzzleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as? PuzzleViewCell else {
            return PuzzleViewCell()
        }
        
        cell.decorate(with: model.getCell(for: indexPath.row))
        return cell
    }
}

// MARK: - Menu View Delegate Methods
extension PuzzleViewController: MenuViewDelegate {
    
    func displayNewGameMenu() {
        // TODO: new game (pop up with level selection/restart)
    }
    
    func toggleMode() {
        model.toggleMode()
    }
    
    func setActive(value: Value) {
        print(#function)
        numberSelectionPlaceholder.isHidden = true
        model.active = value
        // TODO: display active
    }
    
    func displayNumberSelection() {
        print(#function)
        numberSelectionPlaceholder.isHidden = false
    }
    
    func highlightActive(){
        // TODO: update all cells with active value displayed
        // puzzleCollectionView.reloadItems(at: [IndexPath])
    }
}

//
//  PuzzleViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/23/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//  assist from https://medium.com/@adinugroho/fixed-height-uicollectionview-inside-uitableview-79f24657d08f

import UIKit

class PuzzleViewController: UIViewController {

    // MARK: - Properties
    var model: PuzzleModel!
    
    // MARK: - IBOutlets
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    
    //MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        model = PuzzleModel(targetScore: 170)
        preparePuzzleCollectionView()
    }
    
    func preparePuzzleCollectionView() {
        puzzleCollectionView.dataSource = self
        let sideLength = view.frame.size.width - 20
        let frame = CGRect(x: 10, y: 40.0 , width: sideLength , height: sideLength)
        puzzleCollectionView.frame = frame
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellSingleTapped))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDoubleTapped))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        puzzleCollectionView.addGestureRecognizer(singleTapGesture)
        puzzleCollectionView.addGestureRecognizer(doubleTapGesture)
        puzzleCollectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    // MARK: - Gesture Recognition Functions
    // TODO: Selecting a cell will highlight its column, row, and group.
    // TODO: and add the currently selected number (from menu bar) to the cell (to which view is also determined by the menu bar)
    @objc func cellSingleTapped(gesture: UITapGestureRecognizer){
        guard let position = getCellPosition(atPoint: gesture.location(in: puzzleCollectionView)) else {
            print("\(#function) failed")
            return
        }
        print("\(#function) for \(position.description)")
    }
    
    // TODO: double tapping on a cell when the note layer shows only one value will populate the cell's solution with that noted value
    @objc func cellDoubleTapped(gesture: UITapGestureRecognizer) {
        guard let position = getCellPosition(atPoint: gesture.location(in: puzzleCollectionView)) else {
            print("\(#function) failed")
            return
        }
        print("\(#function) for \(position.description)")
    }
    
    // TODO: long press on a selected cell will display an animated pop-up menu.
    
     @objc func cellLongPressed(gesture: UITapGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        guard let position = getCellPosition(atPoint: gesture.location(in: puzzleCollectionView)) else {
            print("\(#function) failed")
            return
        }
        print("\(#function) for \(position.description)")
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

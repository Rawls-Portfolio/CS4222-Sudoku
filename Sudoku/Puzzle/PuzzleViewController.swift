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
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.layer.borderColor = UIColor.green.cgColor
        puzzleCollectionView.layer.borderWidth = 2
    }
}

// MARK: - Collection View Methods
extension PuzzleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

//
//  PuzzleViewCell.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/27/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class PuzzleViewCell: UICollectionViewCell {
    // MARK: - Properties
    private var _position: Position?
    var position: Position? {
        return _position
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var notes: NotesView!
    @IBOutlet weak var solution: SolutionView!
    
    // MARK: - Methods
    func decorate(with cell: Cell){
        self._position = cell.position
        self.solution.label.text = cell.solution?.rawValue ?? " "
        
    }
}

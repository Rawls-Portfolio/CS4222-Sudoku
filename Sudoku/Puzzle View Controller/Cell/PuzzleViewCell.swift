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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    func decorate(with cell: Cell){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self._position = cell.position
        self.notes.labels.forEach{$0.isHidden = true}
        // self.solution.isHidden = true
        self.solution.label.text = cell.solution?.rawValue ?? " "
        
    }
}

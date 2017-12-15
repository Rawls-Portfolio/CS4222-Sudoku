//
//  Style.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/30/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit
class Style {
    static var notesTextColor = UIColor(red: 57/255, green: 79/255, blue: 22/255, alpha: 1.0) // forest green
    static var normalBGColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0) // grey
    static var permanentTextColor =  UIColor(red: 57/255, green: 43/255, blue: 32/255, alpha: 1.0) // brown
    static var solutionTextColor = UIColor(red: 222/255, green: 103/255, blue: 93/255, alpha: 1.0) // watermelon
    static var conflictBGColor = UIColor(red: 219/255, green: 145/255, blue: 154/255, alpha: 1.0) // pink
    static var highlightBGColor = UIColor(red: 198/255, green: 207/255, blue: 167/255, alpha: 1.0) // mint
    static var background = UIColor(red: 182/255, green: 175/255, blue: 164/255, alpha: 1.0) // beige
    
    static func applyOverlayStyle(_ layer: CALayer){
        layer.backgroundColor = Style.normalBGColor.cgColor
        layer.borderColor = Style.conflictBGColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10.0
        
        layer.shadowColor = Style.highlightBGColor.cgColor
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    static func applyMenuStyle(_ view: UIView){
        view.layer.backgroundColor = Style.normalBGColor.cgColor
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        view.isHidden = true
    }
}


// MARK: - Collection View Delegate Methods
extension PuzzleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PuzzleViewCell else {
            return
        }
        let puzzleCell = model.getCell(for: indexPath.row)
        
        cell.notes.updateNotes(to: puzzleCell.notes)
        
        switch(puzzleCell.state){
        case .neutral:
            cell.notes.isHidden = puzzleCell.notes.isEmpty ? true : false
            cell.solution.isHidden = puzzleCell.solution == nil ? true : false
            cell.layer.backgroundColor = Style.normalBGColor.cgColor
        case .permanent:
            cell.notes.isHidden = true
            cell.solution.isHidden = false
            cell.layer.backgroundColor = Style.normalBGColor.cgColor
            cell.solution.label.textColor = Style.permanentTextColor
        case .solution:
            cell.notes.isHidden = true
            cell.solution.isHidden = false
            cell.layer.backgroundColor = Style.normalBGColor.cgColor
            cell.solution.label.textColor = Style.solutionTextColor
        }
        
        if puzzleCell.conflict {
            cell.layer.backgroundColor = Style.conflictBGColor.cgColor
        } else if puzzleCell.highlight {
            cell.layer.backgroundColor = Style.highlightBGColor.cgColor
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
    }
}

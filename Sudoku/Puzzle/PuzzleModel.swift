//
//  PuzzleModel.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/27/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import Foundation

class PuzzleModel {
    // MARK: - Properties
    private var solution: [Int]
    private var puzzle = [Cell]()
    private let difficulty: Int
    private var undoHistory = [Cell]()
    
    
    // MARK: - Methods
    init(targetScore: Int32) {
        // obtain valid solution
        let data: UnsafeMutablePointer<UInt8> = generateSolution()
        let generatedSolution = Array(UnsafeBufferPointer(start: data, count: 81))
        
        // obtain puzzle from given solution and save difficulty value
        let generatedPuzzle = Array(UnsafeBufferPointer(start: data, count: 81))
        let solutionPointer = UnsafeMutablePointer<UInt8>(mutating: generatedSolution)
        let puzzlePointer = UnsafeMutablePointer<UInt8>(mutating: generatedPuzzle)
        difficulty = Int(harden_puzzle(solutionPointer, puzzlePointer, MAX_ITER, MAX_SCORE, targetScore))
        
        // save puzzle and solution
        solution = generatedSolution.map{Int($0)}
       
        generatedPuzzle.map{Int($0)}.forEach{(value) in
            let cellValue = Value.of(value)
            let mode: Mode = cellValue == nil ? .editable : .permanent
            let position = Position(arrayIndex: puzzle.count)
            let newCell = Cell(position: position, notes: [Value](), solution: cellValue, mode: mode)
            puzzle.append(newCell)
        }
        
        free(data) //dynamically allocated in the generator
    }
    
    func getCell(for cell: Int)-> Cell {
        return puzzle[cell]
    }
}

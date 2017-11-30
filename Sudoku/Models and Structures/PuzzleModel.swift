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
    private var mode: Mode
    private var _active: Value
    var active: Value {
        get {
            return _active
        }
        set {
            _active = newValue
        }
    }
    
    let getSwiftyRandom: swiftFuncPtr = { 
        return Int32(arc4random_uniform(UInt32(Int32.max)))
    }
    
    // MARK: - Methods
    init(targetScore: Int32) {
        mode = .solution
        _active = .one
        // obtain valid solution
        let data: UnsafeMutablePointer<UInt8> = generateSolution(getSwiftyRandom)
        let generatedSolution = Array(UnsafeBufferPointer(start: data, count: 81))
        // obtain puzzle from given solution and save difficulty value
        let generatedPuzzle = Array(UnsafeBufferPointer(start: data, count: 81))
        let solutionPointer = UnsafeMutablePointer<UInt8>(mutating: generatedSolution)
        let puzzlePointer = UnsafeMutablePointer<UInt8>(mutating: generatedPuzzle)
        difficulty = Int(generatePuzzle(solutionPointer, puzzlePointer, MAX_ITER, MAX_SCORE, targetScore))
        
        // save puzzle and solution
        solution = generatedSolution.map{Int($0)}
       
        generatedPuzzle.map{Int($0)}.forEach{(value) in
            let cellValue = Value.of(value)
            let position = Position(arrayIndex: puzzle.count)
            let newCell = Cell(position: position, solution: cellValue)
            puzzle.append(newCell)
        }
        
        free(data) //dynamically allocated in the generator
    }
    
    func toggleMode(){
        mode = mode.toggle
    }
    
    func getCell(for cell: Int)-> Cell {
        return puzzle[cell]
    }
    
    func getNoteValue(for cell: Int) -> Value? {
        if puzzle[cell].notes.count == 1 {
            return puzzle[cell].notes.first!
        } else {
            return nil
        }
    }
    
    // damn I love high order functions❣️
    func getActiveIndices(for value: Value) -> [Int] {
        return puzzle.filter{$0.solution == value}.map{$0.position.toIndex}
        
    }
    
    func clearSolution(of value: Value, for cell: Int, transition: ()->() ){
        puzzle[cell].solution = nil
        transition()
    }
    
    func clearNotes(for cell: Int){
        puzzle[cell].notes.removeAll()
    }
    
    func setSolution(of value: Value, for cell: Int, transition: (Bool) -> ()) {
        validateSolution(of: value, for: cell) { (success) in
            if success {
                puzzle[cell].solution = value
                transition(true)
            } else {
                puzzle[cell].state = .conflict
                // TODO: locate other cells in conflict and mark them
            }
        }
    }
    
    func validateSolution(of: Value, for cell: Int, completion: (Bool) -> ()) {
        // TODO: validate
        completion(true)
    }
}

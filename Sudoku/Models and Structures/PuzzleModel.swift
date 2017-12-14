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
    private var _mode: Mode
    private var _active: Value
    private var _lastHighlights = [Int]()
    private var _lastConflict = [Int]()
    var needsUpdate = [Int]()
    
    var active: Value {
        get { return _active }
        set { _active = newValue }
    }
    
    var mode: Mode {
        get { return _mode }
        set { _mode = newValue }
    }
    
    let getSwiftyRandom: swiftFuncPtr = { 
        return Int32(arc4random_uniform(UInt32(Int32.max)))
    }
    
    // MARK: - Methods
    init(targetScore: Int32) {
        _mode = .solution
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
    func getActiveIndices() -> [Int] {
        return puzzle.filter{$0.solution == _active}.map{$0.position.toIndex}
        
    }
    
    func applyHighlights(to cells: [Int]){
        cells.forEach{(cell) in puzzle[cell].highlight = true }
        needsUpdate += cells
        _lastHighlights = cells
    }
    
    func removeEffects(){
        _lastHighlights.forEach{(cell) in puzzle[cell].highlight = false }
        needsUpdate += _lastHighlights
        _lastHighlights.removeAll()
 
        _lastConflict.forEach{(cell) in puzzle[cell].conflict = false }
        needsUpdate += _lastConflict
        _lastConflict.removeAll()
    }
    
    func clearSolution(of value: Value, for cell: Int){
        puzzle[cell].solution = nil
    }
    
    func clearNotes(for cell: Int){
        puzzle[cell].notes.removeAll()
    }
    
    func toggleNote(of value: Value, for cell: Int){
        removeEffects()
        
        guard mode == .notes, puzzle[cell].solution == nil else { return }
        if let valueIndex = puzzle[cell].notes.index(of: value) {
            puzzle[cell].notes.remove(at: valueIndex)
        } else {
            puzzle[cell].notes.append(value)
        }
    }
    
    func setSolution(of value: Value, for position: Position) {
        removeEffects()
        
        func validSolution(of value: Value, for position: Position) -> Bool {
            var success = true
            let checkList = Position.colIndices(position.col) + Position.rowIndices(position.row) + Position.blockIndices(position.block)
            checkList.filter{$0 != position.toIndex}.forEach{(cell) in
                if let solution = puzzle[cell].solution, solution == value {
                    puzzle[cell].conflict = true
                    _lastConflict.append(cell)
                    success = false
                }
            }
            return success
        }
        
        let cell = position.toIndex
        guard puzzle[cell].state != .permanent else { return }
        
        if validSolution(of: value, for: position) {
            puzzle[cell].solution = value
            puzzle[cell].state = .solution
            puzzle[cell].notes.removeAll()
        } else {
            puzzle[cell].conflict = true
            _lastConflict.append(cell)
            needsUpdate += _lastConflict
        }
    }
}

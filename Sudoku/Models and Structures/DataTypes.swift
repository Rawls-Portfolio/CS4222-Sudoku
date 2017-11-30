//
//  DataTypes.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/27/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import Foundation

enum Mode {
    case notes, solution
    
    var toggle: Mode {
        switch(self){
        case .notes: return .solution
        case .solution: return .notes
        }
    }
}

enum State {
    case normal, permanent, solution, conflict
}

struct Cell {
    let position: Position
    var notes: [Value]
    var solution: Value?
    var state: State
    
    init(position: Position, solution: Value?){
        self.position = position
        self.notes = [Value]()
        self.solution = solution
        self.state = solution == nil ? .normal : .permanent
    }
}

struct Position {
    let row: Int
    let col: Int
    let block: Int
    
    var toIndex: Int {
        return (row * 9) + col
    }
    
    var description: String {
        return "Row: \(row + 1), Col: \(col + 1), Block: \(block)"
    }
    
    var rowIndices: (Int) -> [Int] = {(row) in
        var indices = [Int]()
        let startOfRow = 9 * row
        for index in startOfRow..<startOfRow+9{
            indices.append(index)
        }
        return indices
    }
    
    var colIndices: (Int) -> [Int] = {(col) in
        var indices = [Int]()
        for multiplier in 0..<9 {
            indices.append(multiplier * 9 + col)
        }
        return indices
    }
    
    var blockIndices: (Int) -> [Int] = {(block) in
        switch (block){
        case 0: return [0, 1, 2, 9, 10, 11, 18, 19, 20]
        case 1: return [3, 4, 5, 12, 13, 14, 21, 22, 23]
        case 2: return [6, 7, 8, 15, 16, 17, 24, 25, 26]
        case 3: return [27, 28, 29, 36, 37, 38, 45, 46, 47]
        case 4: return [30, 31, 32, 39, 40, 41, 48, 49, 50]
        case 5: return [33, 34, 35, 42, 43, 44, 51, 52, 53]
        case 6: return [54, 55, 56, 63, 64, 65, 72, 73, 74]
        case 7: return [57, 58, 59, 66, 67, 68, 75, 76, 77]
        case 8: return [60, 61, 62, 69, 70, 71, 78, 79, 80]
        default: return []
        }
    }
    
    init(arrayIndex: Int){
        col = arrayIndex % 9
        row = arrayIndex / 9
        switch(arrayIndex){
        case let x where blockIndices(0).contains(x):
            block = 0
        case let x where blockIndices(1).contains(x):
            block = 1
        case let x where blockIndices(2).contains(x):
            block = 2
        case let x where blockIndices(3).contains(x):
            block = 3
        case let x where blockIndices(4).contains(x):
            block = 4
        case let x where blockIndices(5).contains(x):
            block = 5
        case let x where blockIndices(6).contains(x):
            block = 6
        case let x where blockIndices(7).contains(x):
            block = 7
        case let x where blockIndices(8).contains(x):
            block = 4
        default:
            block = -1;
            print("Error: Invalid block assignment")
        }
    }
}

enum Value: String{
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    var index: Int { // to save my brain when accessing array position
        return self.hashValue
    }
    var digit: Int {
        return self.hashValue + 1
    }
    static func of(_ integer: Int)-> Value? {
        switch(integer){
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        case 6: return .six
        case 7: return .seven
        case 8: return .eight
        case 9: return .nine
        default: return nil
        }
    }
}

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
    
    init(arrayIndex: Int){
        col = arrayIndex % 9
        row = arrayIndex / 9
        switch(arrayIndex + 1){
        case 1...3, 10...12, 19...21:
            block = 1
        case 4...6, 13...15, 22...24:
            block = 2
        case 7...9, 16...18, 25...27:
            block = 3
        case 28...30, 37...39, 46...48:
            block = 4
        case 31...33, 40...42, 49...51:
            block = 5
        case 34...36, 43...45, 52...54:
            block = 6
        case 55...57, 64...66, 73...75:
            block = 7
        case 58...60, 67...69, 76...78:
            block = 8
        case 61...63, 70...72, 79...81:
            block = 9
        default:
            block = 0;
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

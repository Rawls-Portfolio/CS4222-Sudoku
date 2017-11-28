//
//  ViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/23/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // obtain solution
        let data: UnsafeMutablePointer<UInt8> = generateSolution()
        let solution = Array(UnsafeBufferPointer(start: data, count: 81))
        
        // obtain puzzle
        let puzzle = Array(UnsafeBufferPointer(start: data, count: 81))
        let difficulty = harden_puzzle(UnsafeMutablePointer<UInt8>(mutating: solution), UnsafeMutablePointer<UInt8>(mutating: puzzle), MAX_ITER, MAX_SCORE, 170)
        
        free(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  NotesView.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/27/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class NotesView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet var labels: [NotesLabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView(){
        backgroundColor? = UIColor(white: 1.0, alpha: 0.0)
    }
    
    func updateNotes(to notes: [Value]){
        for (index, label) in labels.enumerated() {
            label.isHidden = notes.map{$0.index}.contains(index) ? false : true;
        }
    }
}

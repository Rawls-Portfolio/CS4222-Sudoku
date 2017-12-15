//
//  HelpViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/15/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//

import UIKit

class HelpViewController: StyleViewController {

    @IBOutlet weak var text: UITextView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestures()
        view.layer.backgroundColor = UIColor.clear.cgColor
        Style.applyOverlayStyle(text.layer)
        text.text = """
        Swipe left or right to dismiss this help screen.
        
        
        Game Menu:
        The first button displays either a pen or a pencil. The pen indicates you are in Solution Mode. The pencil indicates you are in the Notes Mode.
        
        The second button displays the currently selected number. Tapping on this button will highlight all instances of that number. Holding or double tapping this number will allow you to select another number.
        
        The third button displays a menu.
        
        Cell Interaction:
        Tapping any valid cell on the board will enter the selected number into the selected cell in the indicated mode.
        
        Double tapping on that cell when a single value is shown in notes for that cell will cause that number to be entered as the solution for that cell.
        
        Long pressing on a cell will display a menu.
        - Clear Cell Contents: clears both solution and notes
        - Make Solution Permanent: this value will be saved and be rendered uneditable, even when restarting the game
        - Get Hint: fill the cell with the permanent solution.
        """
        text.clipsToBounds = true
        text.backgroundColor = Style.normalBGColor
        text.textColor = Style.permanentTextColor
    }
    
    func addSwipeGestures(){
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(returnToGame))
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(returnToGame))
        swipeGestureLeft.direction = .left
        self.view.addGestureRecognizer(swipeGestureRight)
        self.view.addGestureRecognizer(swipeGestureLeft)
    }

    @objc func returnToGame(){
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

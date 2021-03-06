//
//  PuzzleViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/23/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.

import UIKit

class PuzzleViewController: StyleViewController {

    // MARK: - Properties
    var model: PuzzleModel!
    var activeCell: Int?
    
    // MARK: - IBOutlets
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    @IBOutlet weak var menu: MenuView!
    @IBOutlet weak var containerView: UIView!
    weak var containerChild: ContainerViewController?
    
    //MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePuzzleCollectionView()
        
        menu.delegate = self
        menu.prepareButtons()
        menu.numberButton.setImage(model.active.image, for: .normal)
        menu.modeButton.setImage(model.mode.image, for: .normal)
        containerView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        if let cv = segue.destination as? ContainerViewController {
            cv.delegate = self
            containerChild = cv

        }
    }
    
    // MARK: - Cell Update Methods
    func highlightPosition(_ position: Position){
        var indices = [Int]()
        indices += Position.rowIndices(position.row) + Position.colIndices(position.col) + Position.blockIndices(position.block)
        model.applyHighlights(to: indices)
        reloadCells()
    }
    
    func getCellPosition(atPoint point: CGPoint) -> Position? {
        guard let selectedIndexPath: IndexPath = puzzleCollectionView.indexPathForItem(at: point),
            let cell = puzzleCollectionView.cellForItem(at: selectedIndexPath) as? PuzzleViewCell,
            let position = cell.position
            else {
                return nil
        }
        return position
    }
    
    func reloadCells(){
        let indices = Array(Set(model.needsUpdate)) // remove duplicates
        let paths = indices.map{IndexPath(item: $0, section: 0)}
        puzzleCollectionView.reloadItems(at: paths)
        model.needsUpdate.removeAll()
        
    }
}

// MARK: - Menu View Delegate Methods
extension PuzzleViewController: MenuViewDelegate {
    func showHelp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let helpView = storyboard.instantiateViewController(withIdentifier: "Help") as? HelpViewController else { return }
        helpView.willMove(toParentViewController: self)
        addChildViewController(helpView)
        view.addSubview(helpView.view)
        helpView.didMove(toParentViewController: self)
    }
    
    func clearSelectedCell() {
        containerChild!.cellOptionsMenu.isHidden = true
        containerView.isHidden = true
        guard let cell = activeCell else { return }
        model.clearSolution(for: cell)
        model.clearNotes(for: cell)
        activeCell = nil
        reloadCells()
    }
    
    func showSelectedHint() {
        containerChild!.cellOptionsMenu.isHidden = true
        containerView.isHidden = true
        guard let cell = activeCell else { return }
        model.showHint(for: cell)
        activeCell = nil
        reloadCells()
    }
    
    func setPermanentState() {
        containerChild!.cellOptionsMenu.isHidden = true
        containerView.isHidden = true
        guard let cell = activeCell else { return }
        model.setPermanentState(of: cell)
        activeCell = nil
        reloadCells()
    }
    
    func clearBoard() {
        containerChild!.newGameMenu.isHidden = true
        containerView.isHidden = true
        model.clearAll()
        puzzleCollectionView.reloadData()
    }
    
    func returnToSelection() {
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
    func closeMenu(){
        containerChild!.cellOptionsMenu.isHidden = true
        containerChild!.newGameMenu.isHidden = true
        containerView.isHidden = true
    }
    func displayNewGameMenu() {
        containerChild!.newGameMenu.isHidden = false
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.duration = 0.25
        fade.fromValue = 0
        fade.toValue = 1
        containerView.layer.add(fade, forKey: nil)
        containerView.isHidden = false
    }
    
    func toggleMode() {
        model.toggleMode()
        menu.modeButton.setImage(model.mode.image, for: .normal)
    }
    
    func setActive(value: Value) {
        containerView.isHidden = true
        model.active = value
        menu.numberButton.setImage(model.active.image, for: .normal)
        highlightActive()
    }
    
    func displayNumberSelection() {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.duration = 0.25
        fade.fromValue = 0
        fade.toValue = 1
        containerView.layer.add(fade, forKey: nil)
        containerView.isHidden = false
        
    }
    
    func highlightActive(){
        model.removeEffects()
        let indices = model.getActiveIndices()
        model.applyHighlights(to: indices)
        reloadCells()
        
    }
}

// MARK: - Collection View Delegate methods located in Style.swift
// MARK: - Collection View Data Source Methods
extension PuzzleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as? PuzzleViewCell else {
            return PuzzleViewCell()
        }
        
        cell.decorate(with: model.getCell(for: indexPath.row))
        return cell
    }
}

// MARK: - Gesture Recognition Functions
extension PuzzleViewController {
    func preparePuzzleCollectionView() {
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.delegate = self
        let sideLength = view.frame.size.width - 20
        let frame = CGRect(x: 10, y: 40.0 , width: sideLength , height: sideLength)
        puzzleCollectionView.frame = frame
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellPressed))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        puzzleCollectionView.addGestureRecognizer(singleTapGesture)
        puzzleCollectionView.addGestureRecognizer(doubleTapGesture)
        puzzleCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    // when cell is single tapped, set solution of cell to that of the active value in solution mode
    // "    "   "   "   ", toggle note value to cell of that of the active value in note mode
    // when cell is double tapped, set solution of cell to that of the note layer, if possible
    @objc func cellTapped(gesture: UITapGestureRecognizer){
        let point = gesture.location(in: puzzleCollectionView)
        guard let position = getCellPosition(atPoint: point) else {
            print("\(#function) failed")
            return
        }
        
        var value: Value?
        switch(gesture.numberOfTapsRequired){
        case 1:
            if model.mode == .solution {
                value = model.active
            } else {
                model.toggleNote(of: model.active, for: position.toIndex)
            }
        case 2:
            value = model.getNoteValue(for: position.toIndex)
        default: print("unknown gesture")
        }
        
        if let solution = value {
            model.setSolution(of: solution, for: position)
        }
        
        highlightPosition(position)
        
    }
    
    // TODO: long press on a selected cell will display an animated pop-up menu.
    @objc func cellPressed(gesture: UITapGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        guard let position = getCellPosition(atPoint: gesture.location(in: puzzleCollectionView)) else {
            print("\(#function) failed")
            return
        }
        
        activeCell = position.toIndex
        containerChild!.cellOptionsMenu.isHidden = false
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.duration = 0.25
        fade.fromValue = 0
        fade.toValue = 1
        containerView.layer.add(fade, forKey: nil)
        containerView.isHidden = false
    }
}

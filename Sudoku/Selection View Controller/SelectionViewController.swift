//
//  SelectionViewController.swift
//  Sudoku
//
//  Created by Amanda Rawls on 12/13/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
// https://www.swiftbysundell.com/posts/ca-gems-using-replicator-layers-in-swift

import UIKit

class SelectionViewController: StyleViewController {
    // MARK: - Properties
//    let pickerData: [Difficulty] = [.easy, .medium, .difficult, .expert]
    var selection = Difficulty.easy

    // MARK: - IBOutlets
    @IBOutlet weak var replicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    // MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        initializeAnimation()
        //        pickerView.dataSource = self
        //        pickerView.delegate = self
    }
    
    // MARK: - Methods
    @IBAction func startGamePressed(_ sender: UIButton) {
        //        print("target difficulty: \(selection.targetScore)")
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        guard let puzzleView = storyboard.instantiateViewController(withIdentifier: "Puzzle") as? PuzzleViewController else { return }
        //        puzzleView.model = PuzzleModel(targetScore: selection.targetScore)
        //        puzzleView.willMove(toParentViewController: self)
        //        addChildViewController(puzzleView)
        //        view.addSubview(puzzleView.view)
        //        puzzleView.didMove(toParentViewController: self)
    }

    func setTitle() {
        titleLabel.textColor = Style.notesTextColor
        titleImage.image = titleImage.image!.withRenderingMode(.alwaysTemplate)
        titleImage.tintColor = Style.permanentTextColor
    }
    
    func initializeAnimation() {
        let dimension = (replicatorView.frame.size.width / 9)
        let delay = TimeInterval(0.1)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.95
        animation.toValue = 0.5
        
        let fade = CABasicAnimation(keyPath: "backgroundColor")
        fade.fromValue = Style.highlightBGColor.cgColor
        fade.toValue = Style.permanentTextColor.cgColor
        
        let group = CAAnimationGroup()
        group.animations = [animation, fade]
        group.duration = 5
        group.autoreverses = true
        group.repeatCount = .infinity
        
        let imageLayer = CALayer()
        imageLayer.cornerRadius = 5.0
        imageLayer.borderColor = Style.permanentTextColor.cgColor
        imageLayer.borderWidth = 1
        imageLayer.frame.size = CGSize(width: dimension, height: dimension)
        imageLayer.add(group, forKey: nil)
        
        let rowLayer = CAReplicatorLayer()
        rowLayer.instanceCount = 9
        rowLayer.instanceTransform = CATransform3DMakeTranslation(dimension, 0, 0)
        rowLayer.instanceDelay = delay
        
        let rootLayer = CAReplicatorLayer()
        rootLayer.frame = replicatorView.frame
        rootLayer.masksToBounds = true
        rootLayer.instanceCount = 9
        rootLayer.instanceTransform = CATransform3DMakeTranslation(0, dimension, 0)
        rootLayer.instanceDelay = delay
        
        rowLayer.addSublayer(imageLayer)
        rootLayer.addSublayer(rowLayer)
        replicatorView.layer.addSublayer(rootLayer)
    }

    @objc func returnToGame(){
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

//extension SelectionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row].description
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//          selection = pickerData[row]
//    }
//}


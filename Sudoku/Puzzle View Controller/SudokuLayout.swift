//
//  SudokuLayout.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/28/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//  layout assist: https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2
//  decoration assist (matt's answer): https://stackoverflow.com/questions/12810628/uicollectionview-decoration-view
import UIKit

class Decoration: UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Style.permanentTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class SudokuLayout: UICollectionViewLayout {
    private var numberOfColumns = 9
    private var numberOfRows = 9
    private var cellPadding : CGFloat = 1
    private var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentWidth : CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var contentHeight : CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private let decorationTitles = ["horizontalBar1", "horizontalBar2", "verticalBar1", "verticalBar2"]
    
    private var horizontalRect: (CGFloat, Int) -> CGRect = { (contentDimension, position) in
        return CGRect(x: 0, y: (contentDimension/9)*CGFloat(position*3)-2, width: contentDimension, height: 4)
    }
    
    private var verticalRect: (CGFloat, Int) -> CGRect = { (contentDimension, position) in
        return CGRect(x: (contentDimension/9)*CGFloat(position*3)-2, y: 0, width: 4, height: contentDimension)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        decorationTitles.forEach{
            register(Decoration.self, forDecorationViewOfKind: $0)
        }
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        contentHeight = contentWidth
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let height = contentHeight/CGFloat(numberOfRows)
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        decorationTitles.forEach{
            if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: $0, at: IndexPath(item:0, section: 0)) {
                if decorationAttributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(decorationAttributes)
                }
            }
        }
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
        
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard decorationTitles.contains(elementKind) else { return nil }
     
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        
        switch(elementKind){
        case decorationTitles[0]: // horizontalBar1
            attributes.frame = horizontalRect(contentWidth, 1)
        case decorationTitles[1]: // horizontalBar2
            attributes.frame = horizontalRect(contentWidth, 2)
        case decorationTitles[2]: // verticalBar1
            attributes.frame = verticalRect(contentWidth, 1)
        case decorationTitles[3]: // verticalBar2
            attributes.frame = verticalRect(contentWidth, 2)
        default: break
        }
        
        return attributes
    }
    
}

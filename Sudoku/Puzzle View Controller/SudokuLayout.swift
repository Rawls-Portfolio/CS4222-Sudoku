//
//  SudokuLayout.swift
//  Sudoku
//
//  Created by Amanda Rawls on 11/28/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//  layout assist: https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2
//  decoration view assist: http://martiancraft.com/blog/2017/05/collection-view-layouts/
import UIKit

class Decoration: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.backgroundColor = Style.permanentTextColor
        self.layer.borderColor = Style.permanentTextColor.cgColor
        self.layer.borderWidth = 2
    }
}

class SudokuLayout: UICollectionViewLayout {
    private var numberOfColumns = 9
    private var numberOfRows = 9
    private var cellPadding : CGFloat = 1
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentWidth : CGFloat {
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

           // let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
           // let height = cellPadding * 2 + photoHeight
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
}

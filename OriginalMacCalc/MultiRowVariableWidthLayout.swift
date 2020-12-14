//
//  HorizontalLayoutVaryingWidths.swift
//  Feline Finder
//
//  Created by Gregory Williams on 10/12/20.
//  Copyright © 2020 Gregory Williams. All rights reserved.
//

import UIKit

protocol MultiRowVariableWidthLayoutDelegate: AnyObject {
    func collectionView(
      _ collectionView: UICollectionView,
      widthForTextAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(
      _ collectionView: UICollectionView,
      maxHeight: CGFloat)
}

class MultiRowVariableWidthAttributes: UICollectionViewLayoutAttributes {
  
  var textWidth: CGFloat = 0
  
  override func copy(with zone: NSZone?) -> Any {
    let copy = super.copy(with: zone) as! MultiRowVariableWidthAttributes
    copy.textWidth = textWidth
    return copy
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let attributes = object as? MultiRowVariableWidthAttributes {
      if attributes.textWidth == textWidth {
        return super.isEqual(object)
      }
    }
    return false
  }
  
}

class MultiRowVariableWidthLayout: UICollectionViewLayout {
  
  var delegate: MultiRowVariableWidthLayoutDelegate!
  var numberOfRows = 1
  var cellPadding: CGFloat = 2.5
  var columnHeight: CGFloat = 40
  var isLandscape = false
  
  var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //Setting the content size
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
  override func prepare() {
    print("Segment Prepare Begin")
    cache.removeAll()
    if cache.isEmpty {
        var yOffsets = [CGFloat]()
        var xOffsets = [CGFloat]()
        var row = -1
        var item2 = -1
        let itemCount = (collectionView?.numberOfItems(inSection: 0))! - 1
        while item2 < itemCount {
            row += 1
            yOffsets.append(CGFloat(row) * columnHeight)
            xOffsets.append(0)
            var nextWidth = CGFloat(0.0)
            while (item2 < itemCount) && (xOffsets[row] + nextWidth < collectionView?.bounds.width ?? 0) {
                item2 += 1
                let indexPath = IndexPath(item: item2, section: 0)
                let width2 = delegate.collectionView(collectionView!, widthForTextAtIndexPath: indexPath) + 5
                
                if (item2 == itemCount) && (xOffsets[row] + width2 > collectionView?.bounds.width ?? 0) {
                    row += 1
                    yOffsets.append(CGFloat(row) * columnHeight)
                    xOffsets.append(0)
                    nextWidth = CGFloat(0.0)
                }
                let frame: CGRect?
                if (item2 == itemCount) && (!isLandscape) {
                    frame = CGRect(x: xOffsets[row], y: yOffsets[row] - columnHeight, width: width2, height: columnHeight * 2)
                } else {
                    frame = CGRect(x: xOffsets[row], y: yOffsets[row], width: width2, height: columnHeight)
                }
                if let frame = frame {
                    var insetFrame = frame
                    if width2 > cellPadding * 2 {
                        insetFrame = frame.insetBy(dx: cellPadding, dy: 5)
                    }
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    xOffsets[row] = xOffsets[row] + width2
                    if item2 < itemCount - 1 {
                    nextWidth = delegate.collectionView(collectionView!, widthForTextAtIndexPath: IndexPath(item: item2 + 1, section: 0)) + 2.0
                    } else {
                        nextWidth = 0
                    }
                }
            }
        }
        delegate.collectionView(collectionView!, maxHeight: (yOffsets.last ?? 0) + columnHeight)
        print("Segment Prepare End")
     }
  }
  
    //Is called  to determine which items are visible in the given rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        //Loop through the cache and look for items in the rect
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    //The attributes for the item at the indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

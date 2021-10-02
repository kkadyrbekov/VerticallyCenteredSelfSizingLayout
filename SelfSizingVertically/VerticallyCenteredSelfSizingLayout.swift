import UIKit

protocol VerticallyCenteredSelfSizingLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class VerticallyCenteredSelfSizingLayout: UICollectionViewLayout {
    weak var delegate: VerticallyCenteredSelfSizingLayoutDelegate?
    var numberOfColumns = 2
    var cellPadding: CGFloat = 0
    var cellHeight: CGFloat = 56
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func invalidateLayout() {
        cache.removeAll()
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        var xOffset: [CGFloat] = []
        var yOffset: [CGFloat] = [0.0, cellHeight / 2]
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * (contentWidth / 2 - 12))
        }
        
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let maxCellWidth = contentWidth / 2
            
            var cellWidth = delegate?.collectionView(collectionView, widthForCellAtIndexPath: indexPath) ?? 180
            cellWidth = cellWidth > maxCellWidth ? maxCellWidth : cellWidth
            
            var frame: CGRect?
            if column == 1 {
                frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth + 14, height: cellHeight)
            } else {
                frame = CGRect(x: maxCellWidth - cellWidth + 12, y: yOffset[column], width: cellWidth, height: cellHeight)
            }

            let insetFrame = frame!.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame!.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
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

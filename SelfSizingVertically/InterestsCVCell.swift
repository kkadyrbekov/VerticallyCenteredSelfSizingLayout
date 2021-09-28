import UIKit

protocol TagsCollectionViewCellDelegate: AnyObject {
    func didSelectCell(_ cell: InterestsCVCell)
}

class InterestsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    var isSelectedItem: Bool = false
    weak var delegate: TagsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(tag: String, index: Int, isSelected: Bool) {
        isSelectedItem = isSelected
        textLabel.text = "\(tag.uppercased()) (\(index))"
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let _rect = self.bounds.insetBy(dx: 1, dy: 1)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: _rect.maxX - 20, y: _rect.minY))
        bezierPath.addLine(to: CGPoint(x: _rect.maxX, y: _rect.maxY / 2))
        bezierPath.addLine(to: CGPoint(x: _rect.maxX - 20, y: _rect.maxY))
        bezierPath.addLine(to: CGPoint(x: _rect.minX + 20, y: _rect.maxY))
        bezierPath.addLine(to: CGPoint(x: _rect.minX, y: _rect.maxY / 2))
        bezierPath.addLine(to: CGPoint(x: _rect.minX + 20, y: _rect.minY))
        bezierPath.close()
        
        bezierPath.lineWidth = 2
        
        if isSelectedItem {
            let shape = CAShapeLayer()
            shape.path = bezierPath.cgPath
            shape.name = "shape"
            layer.addSublayer(shape)
            
            let gradient = CAGradientLayer()
            gradient.frame = bezierPath.bounds
            gradient.colors = [UIColor(named: "gradient1")!.cgColor,
                               UIColor(named: "gradient2")!.cgColor]
            
            let shapeMask = CAShapeLayer()
            shapeMask.path = bezierPath.cgPath
            gradient.mask = shapeMask
            gradient.name = "gradient"
            
            layer.addSublayer(gradient)
            layer.addSublayer(textLabel.layer)
        } else {
            for layer in layer.sublayers ?? [] {
                if layer.name == "gradient" {
                    layer.removeFromSuperlayer()
                }
                if layer.name == "shape" {
                    layer.removeFromSuperlayer()
                }
            }
            UIColor.white.set()
            bezierPath.stroke()
        }
    }
}

extension InterestsCVCell {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08,
                                      execute: {
                                        UIView.animate(withDuration: 0.2) {
                                            self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                                            self.delegate?.didSelectCell(self)
                                        }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.96, y: 0.96)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }
    }
}

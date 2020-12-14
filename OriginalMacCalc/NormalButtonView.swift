//
//  NormalButtonView.swift
//  OriginalMacCalc
//
//  Created by Gregory Williams on 12/6/20.
//

import UIKit

@IBDesignable
class NormalButtonView: UIView, UIGestureRecognizerDelegate {
    
    var invert = false
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        invert = true
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        invert = false
        self.setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        invert = false
        self.setNeedsDisplay()
    }
    
    @IBInspectable dynamic var title: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable dynamic var shadowoffset: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
        
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
        //// ButtonShadow Drawing
            
        let w = rect.width - shadowoffset
        let h = rect.height - shadowoffset
        
        let buttonShadowPath = UIBezierPath(roundedRect: CGRect(x: shadowoffset, y: shadowoffset, width: w, height: h), cornerRadius: 10)
        UIColor.black.setFill()
        buttonShadowPath.fill()
        UIColor.black.setStroke()
        buttonShadowPath.lineWidth = 1
        buttonShadowPath.stroke()

        //// Button Drawing
        let buttonRect = CGRect(x: 0, y: 0, width: w, height: h)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: 10)
        if invert {
            UIColor.black.setFill()
            buttonPath.fill()
            UIColor.white.setStroke()
        } else {
            UIColor.white.setFill()
            buttonPath.fill()
            UIColor.black.setStroke()
        }
        buttonPath.lineWidth = 1
        buttonPath.stroke()
        let buttonTextContent = NSString(string: title)
        print("Title = \(title)")
        let buttonStyle = NSMutableParagraphStyle()
        buttonStyle.alignment = .center

        let buttonFontAttributes = [NSAttributedString.Key.font: UIFont(name: "Chicago Bold", size: 36)!, NSAttributedString.Key.foregroundColor: invert ? UIColor.white : UIColor.black, NSAttributedString.Key.paragraphStyle: buttonStyle]

        let buttonTextHeight: CGFloat = buttonTextContent.boundingRect(with: CGSize(width: buttonRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: buttonFontAttributes, context: nil).size.height
        context.saveGState()
        context.clip(to: buttonRect)
        buttonTextContent.draw(in: CGRect(x: buttonRect.minX, y: buttonRect.minY + (buttonRect.height - buttonTextHeight) / 2, width: buttonRect.width, height: buttonTextHeight), withAttributes: buttonFontAttributes)
        context.restoreGState()
        }
    }
}

extension UIView {

    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }

}

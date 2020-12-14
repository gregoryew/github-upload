//
//  OriginalMacCslc.swift
//  OriginalMacCalc
//
//  Created by Gregory Williams on 12/6/20.
//

import UIKit

@IBDesignable
class OriginalMacCalc: UIView {
    @IBInspectable dynamic var displayLabel: String = "0" {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        //// Color Declarations
        let color = UIColor(red: 0.703, green: 0.699, blue: 0.699, alpha: 1.000)

        let backgroundPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), cornerRadius: 0)
        UIColor.clear.setFill()
        backgroundPath.fill()
        
        //// OutlineShadow1 Drawing
        let outlineShadow1Path = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: rect.width, height: rect.height - 42), cornerRadius: 30)
        UIColor.black.setFill()
        outlineShadow1Path.fill()
                
        //// OutlineShadow2 Drawing
        let outlineShadow2Path = UIBezierPath(roundedRect: CGRect(x: 25, y: rect.height - 60, width: rect.width - 25, height: 30), cornerRadius: 30.0)
        UIColor.black.setFill()
        outlineShadow2Path.fill()
        
        //// Frame Drawing
        let framePath = UIBezierPath(roundedRect: CGRect(x: 9, y: 67.5, width: rect.width - 20, height: rect.height - (459 - 399) - 50), cornerRadius: 30)
        color.setFill()
        UIColor.black.setStroke()
        framePath.lineWidth = 3
        framePath.fill()
        
        //// CloseBox Drawing
        let closeBoxPath = UIBezierPath(rect: CGRect(x: 40, y: 18, width: 36, height: 36))
        UIColor.black.setFill()
        closeBoxPath.fill()
        UIColor.white.setStroke()
        closeBoxPath.lineWidth = 1.5
        closeBoxPath.stroke()

        //// CalculatorLabel Drawing
        let calculatorLabelRect = CGRect(x: 100, y: 22, width: 200, height: 37)
        let calculatorLabelStyle = NSMutableParagraphStyle()
        calculatorLabelStyle.alignment = .left

        let calculatorLabelFontAttributes = [NSAttributedString.Key.font: UIFont(name: "Chicago Bold", size: 33)!, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: calculatorLabelStyle]

        "Calculator".draw(in: calculatorLabelRect, withAttributes: calculatorLabelFontAttributes)
    }
}

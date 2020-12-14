//
//  ViewController.swift
//  OriginalMacCalc
//
//  Created by Gregory Williams on 12/6/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MultiRowVariableWidthLayoutDelegate {
    
    var maxHeight = 0
    var buttons = [String]()
    var buttonWidth = CGFloat(0)
    
    var portraitButtonWidth = CGFloat(0)
    var portraitCollectionViewWidth = CGFloat(0)
    var porttaitColumnHeight = CGFloat(0)
    let buttonsPortrait = ["C", "CE", "/", "*", "7", "8", "9", "-", "4", "5", "6", "+", "1", "2", "3", "S", "0", ".", "="]

    var landscapeButtonWidth = CGFloat(0)
    var landscapeCollectionViewWidth = CGFloat(0)
    var landscapeColumnHeight = CGFloat(0)
    let buttonsLandscape = ["1", "2", "3", "4", "5", "+", "-", "C", "CE", "6", "7", "8", "9", "0", "*", "/", "=", "."]
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var displayHeight: NSLayoutConstraint!
    
    @IBOutlet weak var calculatorButtonsCollectionView: UICollectionView!
    @IBOutlet weak var display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorButtonsCollectionView.delegate = self
        calculatorButtonsCollectionView.dataSource = self

        calculateRowHeightsAndColumnWidths()
        
        display.text = "0"

        calculatorButtonsCollectionView.isUserInteractionEnabled = true
    }
    
    func calculateRowHeightsAndColumnWidths() {
        landscapeButtonWidth = max(60, CGFloat((CGFloat(self.view.frame.height) / CGFloat(7.5)) - (8.5 * 5)))
        landscapeCollectionViewWidth = (landscapeButtonWidth * 10.2)
        landscapeColumnHeight = ((CGFloat(self.view.frame.height) / CGFloat(6.5))) - (5 * 7)
        
        portraitButtonWidth = CGFloat((CGFloat(self.view.frame.width) / CGFloat(4.5)) - (5 * 5))
        portraitCollectionViewWidth = (portraitButtonWidth * 4) + 20
        porttaitColumnHeight = CGFloat((CGFloat(self.view.frame.height) / CGFloat(6)) - (5 * 7))

        getCorrectButtons()
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorButtonsCollectionView.dequeueReusableCell(withReuseIdentifier: "CalcButton", for: indexPath) as! CalcButtonCellCollectionViewCell
        guard indexPath.item < buttons.count else {return cell}
        cell.configure(title: buttons[indexPath.item])
        cell.setNeedsDisplay()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        var width = buttonWidth
        if buttons[indexPath.item] == "S" {
            width = 0
        } else if indexPath.item == 16 && !Orientation.isLandscape {
            width = (buttonWidth * 2) + 5
        }
        return CGFloat(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, maxHeight: CGFloat) {
        collectionViewHeight.constant = maxHeight
    }
    
    func getCorrectButtons() {
        var rowHeight: CGFloat?
        if (Orientation.isLandscape) {
            buttonWidth = landscapeButtonWidth
            collectionViewWidth.constant = landscapeCollectionViewWidth
            buttons = buttonsLandscape
            rowHeight = max(landscapeColumnHeight, buttonWidth)
        } else {
            buttonWidth = portraitButtonWidth
            collectionViewWidth.constant = portraitCollectionViewWidth
            buttons = buttonsPortrait
            rowHeight = max(porttaitColumnHeight, buttonWidth)
        }
        let layout = calculatorButtonsCollectionView.collectionViewLayout as! MultiRowVariableWidthLayout
        layout.columnHeight = max(rowHeight!, buttonWidth)
        layout.isLandscape = Orientation.isLandscape
        displayHeight.constant = layout.columnHeight * 0.5
        layout.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        getCorrectButtons()
                
        DispatchQueue.main.async(execute: {
            self.calculatorButtonsCollectionView.reloadData()
            self.view.setNeedsDisplay()
        })
    }
    
    var currentNumber: Double?
    var displayedNumber: String = "0"
    var result: Double?
    var currentOp = ""
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func performOp(op: String) {
            if var result = result, let currentNumber = currentNumber {
                switch op {
                case "+":
                    result += currentNumber
                case "-":
                    result -= currentNumber
                case "*":
                    result *= currentNumber
                case "/":
                    result /= currentNumber
                default: fatalError("Unknown Button")
                }
                self.result = result
            }
        }

        func RemoveTrailingZeroes(_ num: String) -> String {
            let digits = Array(num)
            var pos: Int?
            for i in stride(from: num.count - 1, to: 0, by: -1) {
                if digits[i] == "." || digits[i] != "0" {
                    pos = i
                    break
                }
            }
            if let pos = pos {
                if digits[pos] == "." {
                    return String(digits[0..<pos])
                } else {
                    return String(digits[0...pos])
                }
            } else {
                return num
            }
        }
                
        let button = buttons[indexPath.item]
        switch button {
        case "0"..."9", ".":
            if displayedNumber.contains(".") && button == "." {
                return
            }
            if displayedNumber == "0" && button != "." {
                displayedNumber = ""
            }
            displayedNumber = displayedNumber + button
            if let num = Double(displayedNumber) {
                currentNumber = num
            } else {
                currentNumber = 0
            }
            display.text = RemoveTrailingZeroes(String(format: "%f", currentNumber!))
        case "+", "-", "*", "/":
            if currentNumber != nil && result != nil {
                performOp(op: button)
                display.text = RemoveTrailingZeroes(String(format: "%f", result!))
            } else if result == nil {
                result = currentNumber
            }
            currentOp = button
            currentNumber = 0.0
            displayedNumber = "0"
        case "C", "CE":
            currentNumber = nil
            display.text = RemoveTrailingZeroes(String(format: "%f", 0))
            displayedNumber = "0"
            if button == "C" {result = nil}
        case "=":
            if currentOp != "" {performOp(op: currentOp)}
            if let result = result {
                display.text = RemoveTrailingZeroes(String(format: "%f", result))
            }
            currentNumber = nil
        default: fatalError("Unknown Button")
        }
    }
}

struct Orientation {
    // indicate current device is in the LandScape orientation
    static var isLandscape: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isLandscape
                : (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!
        }
    }
    // indicate current device is in the Portrait orientation
    static var isPortrait: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isPortrait
                : (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait)!
        }
    }
}

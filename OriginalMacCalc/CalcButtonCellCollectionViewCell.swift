//
//  CalcButtonCellCollectionViewCell.swift
//  OriginalMacCalc
//
//  Created by Gregory Williams on 12/6/20.
//

import UIKit

class CalcButtonCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var calcButtonView: NormalButtonView!
    
    func configure(title: String) {
        isUserInteractionEnabled = true
        calcButtonView.title = title
    }
}

//
//  IntroCell.swift
//  Sudoku
//
//  Created by James Thang on 7/3/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var introLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        introImage.layer.borderWidth = 3
        
    }

}

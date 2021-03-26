//
//  TagCollectionViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mTag : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData(tag : String){
        mTag.text = tag
    }
}

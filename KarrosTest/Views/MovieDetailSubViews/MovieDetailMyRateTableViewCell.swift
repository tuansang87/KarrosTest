//
//  MovieDetailCommentTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailMyRateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mRatingNo : UILabel!
    @IBOutlet var mRatingStars : [UIButton]!
    var lastStarNo : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(){
        
    }
        
    @IBAction func didClickOnStarBtn(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        var currStar = sender.tag
        if lastStarNo == sender.tag {
            currStar = currStar - (sender.isSelected ? 0 : 1)
        }
        for btn in mRatingStars {
            btn.isSelected = btn.tag <= currStar
            btn.tintColor = .red
        }
        let str = String(format: "%.1f", CGFloat(currStar))
        mRatingNo.text =  str
        lastStarNo = currStar
    }
}

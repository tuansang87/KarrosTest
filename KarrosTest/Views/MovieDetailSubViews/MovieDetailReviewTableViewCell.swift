//
//  MovieDetailBannerTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit

class MovieDetailReviewTableViewCell: UITableViewCell {
    @IBOutlet var mAvatar : UIImageView!
    @IBOutlet var mLblName : UILabel!
    @IBOutlet var mLlblReview : UILabel!
    @IBOutlet var  mLlblDate : UILabel!
    @IBOutlet var  mLlblRateNo : UILabel!
    
    @IBOutlet var mRateStars : [UIImageView]!
    
    var review : ReviewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mAvatar.image = nil
        mLblName.text  = ""
        mLlblReview.text  = ""
        mLlblDate.text  = ""
        mLlblRateNo.text  = ""
    }
    
    
    func loadData(_ review: ReviewModel){
        self.review = review
         
        if let path = review.author_details?.avatar_path {
            var uriPath = ""
            if path.contains("http") {
                uriPath = path.replacingOccurrences(of: "/http", with: "http")
            } else {
                uriPath = "https://image.tmdb.org/t/p/original/\(path)"
            }
            mAvatar.sd_setImage(with: URL(string: uriPath), completed: nil)
        }
        
        mLblName.text = review.author
        mLlblReview.text = review.content
        if let str = review.updated_at {
            
            mLlblDate.text = chatMessage(str , "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy HH:mm a")
        }
        
        if let rating = review.author_details?.rating {
            let str = String(format: "%.1f",  (Double(rating) / 2.0))
            mLlblRateNo.text = str
            for v in mRateStars {
                v.image = UIImage(named: Double(v.tag) > (Double(str) ?? 0)  ? "large_empty_rate_ic" : "large_rate_selected_ic")
            }
        }
        
        
    }
    
}

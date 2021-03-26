//
//  MovieDetailRecommendationCollectionViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailRecommendationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mName : UILabel!
    @IBOutlet weak var mImgPoster : UIImageView!
    var mMovie : MovieModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mImgPoster.superview?.dropShadow_10()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mImgPoster.image = nil
        mName.text = ""
        mMovie = nil
    }

    func loadData(_ movie : MovieModel) {
        self.mMovie = movie
        if let poster_path = mMovie?.poster_path {
            mImgPoster.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(poster_path)"), completed: nil)
        }
        
        mName.text = mMovie?.title
    }

}

//
//  MovieDetailVideosCollectionViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailVideosCollectionViewCell: UICollectionViewCell {
     
    @IBOutlet var mImgFeature : UIImageView!
    var mVideoFeature : VideoFeatureModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mImgFeature.image = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mImgFeature.superview?.dropShadow_10()
    }
    
    
    func loadData(_ data : VideoFeatureModel) {
        mVideoFeature = data
        if let path = mVideoFeature?.file_path {
            mImgFeature.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(path)"), completed: nil)
        }
    }
}

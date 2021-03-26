//
//  MovieCollectionViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mContainerView : UIView!
    @IBOutlet weak var mImageView : UIImageView!
    @IBOutlet weak var mTitle : UILabel!
    var mMovie : MovieModel?
    
    override func prepareForReuse() {
        mImageView.image = nil
        mTitle.text = ""
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mTitle.backgroundColor = .white
        mImageView.layer.borderWidth = 0
        mImageView.layer.cornerRadius = 6
        mImageView.contentMode = .scaleAspectFill
        mImageView.clipsToBounds = true
        mImageView.superview?.dropShadow_20()
    }
    
    func loadData(_ data : MovieModel  ) {
        mMovie = data
        if let poster_path = mMovie?.poster_path {
            mImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(poster_path)"), completed: nil)
        }
        mTitle.numberOfLines = 2
        mTitle.text = data.title
        
    }
    
    
    @IBAction func didClickOnCell(){
        NotificationCenter.default.post(name: Notification.Name.init(APP_EVENT.VIEW_MOVIE_DETAIL.rawValue), object: mMovie)
    }
    
}

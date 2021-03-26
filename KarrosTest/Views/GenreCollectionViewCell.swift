//
//  MovieCollectionViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mContainerView : UIView!
    @IBOutlet weak var mImageView : UIImageView!
    @IBOutlet weak var mTitle : UILabel!
    @IBOutlet weak var containerBottomConstraint : NSLayoutConstraint!
    
    var mMovie : Any?
    var index : Int = 0
    override func prepareForReuse() {
        mImageView.image = nil
        mTitle.text = ""
        mMovie = nil
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        mImageView.layer.borderWidth = 0
        mImageView.layer.cornerRadius = 6
        mImageView.clipsToBounds = true
        
        mImageView.contentMode = .scaleAspectFill
    }
    
    func loadData(_ data : Any, index : Int = 0  ) {
        self.index = index
        let idx = index % 3 == 0 ? 1 :( index % 3 == 1 ? 2 : 3)
        
        
        if let data = data as? GenreModel {
            mMovie = data
            mImageView.image = UIImage(named: "genre_rect_bg_\(idx)")
            mTitle.numberOfLines = 0
            mTitle.text = data.name
            
            containerBottomConstraint.constant = 5
            mContainerView.dropShadow_5()
        } else if let data = data as? MovieModel {
            mMovie = data
            if let poster_path = data.poster_path {
                mImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(poster_path)"), completed: nil)
            }
            mTitle.text = ""
            
            containerBottomConstraint.constant = 10
            mContainerView.dropShadow_10()
            
        }
        
    }
    
    
    @IBAction func didClickOnCell(){ 
        NotificationCenter.default.post(name: Notification.Name.init(APP_EVENT.VIEW_MOVIE_DETAIL.rawValue), object: mMovie)
    }
    
}

//
//  MoviveDetailCastingTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailCastingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mName : UILabel!
    @IBOutlet weak var mRole : UILabel!
    @IBOutlet var mImageView :UIImageView!
    
    var cast : Codable?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mImageView.superview?.dropShadow_10()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mImageView.image = nil
        mName.text = ""
        mRole.text = ""
    }
    
    func loadData(_ model : Codable) {
        cast = model
        var candicatePath : String?
        if let cast = cast as? CastModel {
            mName.text = cast.name
            mRole.text = cast.character
            candicatePath = cast.profile_path
                        
        } else if let cast = cast as? CrewModel {
            mName.text = cast.name
            mRole.text = cast.job
            candicatePath = cast.profile_path
            
        }
        
        if let path = candicatePath {
            let mPath = "https://image.tmdb.org/t/p/original/\(path.replacingOccurrences(of: "/", with: ""))";
            mImageView.sd_setImage(with: URL(string:mPath), placeholderImage: UIImage(named: "app_banner"), completed: {[weak self] (img, err, type, url) in
                if let _ = err , let self = self {
                    self.mImageView.image = UIImage(named: "app_banner")
                }
            })
        } else {
            self.mImageView.image = UIImage(named: "app_banner")
        }
        
    }
}

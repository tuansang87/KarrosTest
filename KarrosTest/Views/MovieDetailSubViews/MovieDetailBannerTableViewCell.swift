//
//  MovieDetailBannerTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit

class MovieDetailBannerTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mTagsCollection.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        mTagsCollection.dataSource = self
        mTagsCollection.delegate = self
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mPosterImg.superview?.dropShadow_20()
    }
    
    
    @IBOutlet weak var mBannerImg : UIImageView!
    @IBOutlet weak var mPosterImg : UIImageView!
    
    @IBOutlet weak var mRatingNo : UILabel!
    @IBOutlet var mRatingStars : [UIImageView]!
    @IBOutlet weak var mReleaseDate : UILabel!
    @IBOutlet weak var mTagsCollection : UICollectionView!
    @IBOutlet weak var mMovieName : UILabel!
    @IBOutlet weak var mMovieDesc : UILabel!
    
    
    var mMovie : MovieDetailModel?
    

    override func prepareForReuse() {
        super.prepareForReuse()
        mMovie = nil
        mTagsCollection.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadMovie(_ movie : MovieDetailModel) {
        self.mMovie = movie
        if let path = mMovie?.backdrop_path {
            mBannerImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(path)"), completed: nil)
        }
        
        if let path = mMovie?.poster_path {
            mPosterImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(path)"), completed: nil)
        }
        if let str = mMovie?.release_date {
            
            mReleaseDate.text = formatDateStr(str , "yyyy-MM-dd", toFormat: "MMM yyyy")
        }
        
        
        mMovieName.text = mMovie?.title
        mMovieDesc.text = mMovie?.overview
        let str = String(format: "%.1f", (mMovie?.vote_average ?? 0) / 2)
        for v in mRatingStars {
            v.image = UIImage(named: Double(v.tag) > (Double(str) ?? 0)  ? "large_empty_rate_ic" : "large_rate_selected_ic")
        }
        mRatingNo.text = str
        mTagsCollection.reloadData()
    }
}


extension MovieDetailBannerTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return mMovie?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        if let model = mMovie?.genres?[indexPath.item] {
            
            cell.loadData(tag: model.name ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64 , height: 21)
    }
    
    
}

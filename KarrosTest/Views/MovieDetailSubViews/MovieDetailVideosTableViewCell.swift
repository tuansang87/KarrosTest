//
//  MovieDetailVideosTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailVideosTableViewCell: UITableViewCell {
    @IBOutlet weak var mCollection : UICollectionView!
    var videoFeatures : [VideoFeatureModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollection.register(UINib(nibName: "MovieDetailVideosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieDetailVideosCollectionViewCell")
        mCollection.dataSource = self
        mCollection.delegate = self
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(_ features : [VideoFeatureModel]) {
        videoFeatures = features
        mCollection.reloadData()
    }
    
}


extension MovieDetailVideosTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return videoFeatures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailVideosCollectionViewCell", for: indexPath) as! MovieDetailVideosCollectionViewCell
        let model = videoFeatures[indexPath.item]
            cell.loadData(model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200 , height: 170)
    }
    
    
}

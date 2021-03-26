//
//  MoviveDetailCastingTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailRecommendationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollection : UICollectionView!
    var movies : [MovieModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollection.register(UINib(nibName: "MovieDetailRecommendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieDetailRecommendationCollectionViewCell")
        mCollection.dataSource = self
        mCollection.delegate = self
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(_ movies : [MovieModel]) {
        self.movies = movies
        mCollection.reloadData()
    }
    
}


extension MovieDetailRecommendationTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailRecommendationCollectionViewCell", for: indexPath) as! MovieDetailRecommendationCollectionViewCell
        let model = movies[indexPath.item]
            cell.loadData(model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 , height: 210)
    }
    
    
}

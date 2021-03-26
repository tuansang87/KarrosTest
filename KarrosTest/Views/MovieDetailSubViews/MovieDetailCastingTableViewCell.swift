//
//  MovieDetailCastingTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 25/3/21.
//

import UIKit

class MovieDetailCastingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollection : UICollectionView!
    var seriesCast : [Codable] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollection.register(UINib(nibName: "MovieDetailCastingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieDetailCastingCollectionViewCell")
        mCollection.dataSource = self
        mCollection.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(_ cast : [Codable]) {
        seriesCast = cast
        mCollection.reloadData()
    }
    
}


extension MovieDetailCastingTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return seriesCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCastingCollectionViewCell", for: indexPath) as! MovieDetailCastingCollectionViewCell
        let model = seriesCast[indexPath.item]
            cell.loadData(model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70 , height: 102 + 23 + 14)
    }
    
    
}


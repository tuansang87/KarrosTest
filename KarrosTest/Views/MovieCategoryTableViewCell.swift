//
//  MovieCategoryTableViewCell.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit

class MovieCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollectionView : UICollectionView!
    var movies : [MovieModel] = []
    var genres : [GenreModel] = []
    var category : MOVIE_CATEGORY = .GENRE
    var loadMoreCallback : RawDataCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        mCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
    }
    
    override func prepareForReuse() {
        self.movies.removeAll()
        self.genres.removeAll()
        mCollectionView.reloadData()
        loadMoreCallback = nil
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadData(_ data: [Any] = [], category : MOVIE_CATEGORY = .GENRE, loadMoreCallback : RawDataCallback?) {
        self.category = category
        self.loadMoreCallback = loadMoreCallback
        updateData(data)
    }
    
    func updateData(_ data: [Any] = []) {
        if category != .GENRE , let data = data as? [MovieModel] {
            self.movies.removeAll()
            self.movies.append(contentsOf: data)
        } else if category == .GENRE , let data = data as? [GenreModel] {
            self.genres.removeAll()
            self.genres.append(contentsOf: data)
        }
        
        mCollectionView.reloadData()
        mCollectionView.reloadData()
    }
}


extension MovieCategoryTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category == .GENRE ? genres.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if category == .GENRE {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell {
                cell.loadData(genres[indexPath.item], index: indexPath.item )
                return cell
            }
        } else {
            if category == .TRENDING {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell {
                    cell.loadData(movies[indexPath.item], index: indexPath.item )
                    return cell
                }
            } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
                cell.loadData(movies[indexPath.item])
                return cell
            }
                      
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row ==  movies.count - 1 {  //numberofitem count
                if let loadMoreCallback = loadMoreCallback {
                    loadMoreCallback(category)
                }
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: category == .TRENDING ? 300: 140 , height: category == .GENRE ? 77 :  (category == .TRENDING ? 160 : (210 + 10 + 40)))
    }
    
}

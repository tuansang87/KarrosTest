//
//  ViewController.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit

enum MOVIE_DETAIL_SECTION : Int {
    case Header = 0
    case MyRate = 1
    case Cast = 2
    case Video = 3
    case Comment = 4
    case Recommendations = 5
    
}
class MovieDetailViewController: UIViewController  {
    
    @IBOutlet weak var mTableView : UITableView!
    
    lazy var mPresenter = MovieDetailPresenter(with: self)
    var moviveInfo : MovieModel?
    var mMovie : MovieDetailModel?
    var seriesCast : [Codable] = []
    var videoFeatures : [VideoFeatureModel] = []
    var recommendationMovies : [MovieModel] = []
    var reviews : [ReviewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configUI()
        mPresenter.loadData(with: "\(moviveInfo?.id ?? 791373)")
    }
    
    func configUI(){
        mTableView.dataSource = self
        mTableView.delegate = self
        
        if #available(iOS 11.0, *) {
            mTableView.contentInsetAdjustmentBehavior = .never
        } else {
           self.automaticallyAdjustsScrollViewInsets = false
        }
        
        mTableView.register(UINib(nibName: "MovieDetailBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailBannerTableViewCell")
        
        mTableView.register(UINib(nibName: "MovieDetailMyRateTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailMyRateTableViewCell")
        
        mTableView.register(UINib(nibName: "MovieDetailCastingTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailCastingTableViewCell")
        
        mTableView.register(UINib(nibName: "MovieDetailVideosTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailVideosTableViewCell")
        
        mTableView.register(UINib(nibName: "MovieDetailReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailReviewTableViewCell")
        
        
        mTableView.register(UINib(nibName: "MovieDetailRecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailRecommendationTableViewCell")
        
    }
    
    @IBAction func goBack(){
        navigationController?.popViewController(animated: true)
    }

}

// MARK:- Conform TableView Datasource , Delegate

extension MovieDetailViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let cate = MOVIE_DETAIL_SECTION(rawValue: section) {
            switch cate {
            case .Header:
                return 0
            case .MyRate,.Cast,.Video:
                return 48                
            case .Recommendations :
                return recommendationMovies.count > 0 ? 48 : 0
            case .Comment :
                return reviews.count > 0 ? 48 : 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 48))
        v.backgroundColor = UIColor(hex: "#F8F8F8")!
        let lbl = UILabel(frame: CGRect(x: 20,y: 0,width: UIScreen.main.bounds.width - 20 * 2 - 22,height: 48))
        lbl.font = UIFont(name: "Helvetica-Bold", size: 18)
        var showMoreBtn = false
        if let cate = MOVIE_DETAIL_SECTION(rawValue: section) {
            switch cate {
            case .Header:
                lbl.text = ""
            case .MyRate:
                lbl.text = "Your Rate"
            case .Cast:
                lbl.text = "Series Cast"
            case .Video:
                lbl.text = "Video"
            case .Comment:
                lbl.text = "Comments"
                showMoreBtn = true
            case .Recommendations:
                lbl.text = "Recomendations"
                showMoreBtn = true
            }
        }
        
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 22 - 20 ,y: (48 - 22)/2,width: 22,height: 22))
        btn.setImage(UIImage(named: "viewmore"), for: .normal)
        btn.isHidden = !showMoreBtn
        v.addSubview(lbl)
        v.addSubview(btn)
        return v
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cate = MOVIE_DETAIL_SECTION(rawValue: indexPath.section) {
            switch cate {
            case .Header:
                return 640
            case .MyRate:
                return 180
            case .Cast:
                return 180
            case .Video:
                return 170
            case .Comment:
                return 145
            case .Recommendations:
                return 210
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cate = MOVIE_DETAIL_SECTION(rawValue: section) {
            switch cate {
            case .Header:
                return 1
            case .MyRate:
                return 1
            case .Cast:
                return 1
            case .Video:
                return 1
            case .Comment:
                return min(reviews.count,3 )
            case .Recommendations:
                return 1
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseId = ""
        if let cate = MOVIE_DETAIL_SECTION(rawValue: indexPath.section) {
            switch cate {
            case .Header:
                reuseId = "MovieDetailBannerTableViewCell"
            case .MyRate:
                reuseId = "MovieDetailMyRateTableViewCell"
            case .Cast:
                reuseId = "MovieDetailCastingTableViewCell"
            case .Video:
                reuseId = "MovieDetailVideosTableViewCell"
            case .Comment:
                reuseId = "MovieDetailReviewTableViewCell"
            case .Recommendations:
                reuseId = "MovieDetailRecommendationTableViewCell"
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) {
            if let cell = cell as? MovieDetailBannerTableViewCell , let movie = mMovie {
                cell.loadMovie(movie)
            } else if let cell = cell as? MovieDetailCastingTableViewCell {
                cell.loadData(seriesCast)
            } else if let cell = cell as? MovieDetailVideosTableViewCell {
                cell.loadData(videoFeatures)
            } else if let cell = cell as? MovieDetailRecommendationTableViewCell {
                cell.loadData(recommendationMovies)
            } else if let cell = cell as? MovieDetailReviewTableViewCell {
                cell.loadData(reviews[indexPath.row])
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

// MARK:- Confirm Presenter Interface
extension MovieDetailViewController : MovieDetailPresenterView {
    func reloadVideoFeaturesSection(_ data: [VideoFeatureModel]) {
        videoFeatures = data
        mTableView.reloadRows(at: [IndexPath(row: 0, section: MOVIE_DETAIL_SECTION.Video.rawValue)], with: .automatic)
    }
    
   
    func reloadSeriesCastSection(_ data: [Codable]) {
        seriesCast = data
        mTableView.reloadRows(at: [IndexPath(row: 0, section: MOVIE_DETAIL_SECTION.Cast.rawValue)], with: .automatic)
    }
    
    func reloadData(movie: MovieDetailModel) {
        mMovie = movie
        mTableView.reloadData()
    }
    func reloadRecomendationMovies(with data: [MovieModel]) {
        recommendationMovies = data
        mTableView.reloadRows(at: [IndexPath(row: 0, section: MOVIE_DETAIL_SECTION.Recommendations.rawValue)], with: .automatic)
    }
    
    func reloadMovieReviews(with data: [ReviewModel]) {
        reviews = data
        mTableView.reloadSections(IndexSet(integer: MOVIE_DETAIL_SECTION.Comment.rawValue), with: .automatic)
    }
    
}

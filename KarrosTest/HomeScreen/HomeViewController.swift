//
//  ViewController.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mTopbar : UIView!
    @IBOutlet weak var mTableView : UITableView!
    @IBOutlet weak var mIndicator : UIActivityIndicatorView!
    
    
    lazy var mPresenter = HomePresenter(with: self)
    var refreshControl = UIRefreshControl()
    var genres : [GenreModel] = []
    var trendingMovies : [MovieModel] = []
    var topRatedMovies : [MovieModel] = []
    var popularMovies : [MovieModel] = []
    var upcomingMovies : [MovieModel] = []
    var onFocusedMovie : MovieModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configUI()
        // fetch data
        mPresenter.loadData()
    }
    
    func _configUI(){
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.estimatedRowHeight = 100
        mTableView.register(UINib.init(nibName: "MovieCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCategoryTableViewCell")
        
        let color = UIColor(hex: "#00CBCF")!
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = color
        mTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject?) {
        // Code to refresh table view
        mPresenter.forceReloadData()
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        configUI()
    }
    
    
    
    func configUI() {
        mTopbar.backgroundColor = .white
        mTopbar.dropShadow_10()
    }
}
// MARK:- TableView Delegate/Datasource
extension HomeViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 60))
        let lbl = UILabel(frame: CGRect(x: 20,y: 0,width: UIScreen.main.bounds.width - 20 * 2 - 22,height: 60))
        lbl.font = UIFont(name: "Helvetica-Bold", size: 18)
        if let cate = MOVIE_CATEGORY(rawValue: section){
            switch cate {
            case .GENRE:
                lbl.text = "GENRE"
            case .TRENDING:
                lbl.text = "TRENDING"
            case .TOP_RATED:
                lbl.text = "TOP RATED"
            case .POPULAR:
                
                lbl.text = "POPULAR"
            case .UPCOMMING:
                
                lbl.text = "UPCOMMING"
            }
            
            
        }
        
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 22 - 20 ,y: (60 - 22)/2,width: 22,height: 22))
        btn.setImage(UIImage(named: "viewmore"), for: .normal)
        v.addSubview(lbl)
        v.addSubview(btn)
        return v
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cate = MOVIE_CATEGORY(rawValue: indexPath.section){
            if cate == .GENRE {
                return  77
            } else if cate == .TRENDING {
                return  160
            }
        }
        return (210 + 10 + 40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mTableView.dequeueReusableCell(withIdentifier: "MovieCategoryTableViewCell") as? MovieCategoryTableViewCell {
            if let cate = MOVIE_CATEGORY(rawValue: indexPath.section) {
                switch  cate {
                case MOVIE_CATEGORY.GENRE:
                    cell.loadData(genres, category: .GENRE, loadMoreCallback: self.loadMoreCallback(_:))
                case MOVIE_CATEGORY.TRENDING:
                    cell.loadData(trendingMovies, category: .TRENDING, loadMoreCallback :  self.loadMoreCallback)
                case MOVIE_CATEGORY.TOP_RATED:
                    cell.loadData(topRatedMovies,category: .TOP_RATED, loadMoreCallback:self.loadMoreCallback(_:))
                case MOVIE_CATEGORY.POPULAR:
                    cell.loadData(popularMovies,category: .POPULAR, loadMoreCallback:self.loadMoreCallback(_:))
                case MOVIE_CATEGORY.UPCOMMING:
                    cell.loadData(upcomingMovies, category: .UPCOMMING, loadMoreCallback:self.loadMoreCallback(_:))
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func loadMoreCallback(_ cate: Any) {
        if let cate = cate as? MOVIE_CATEGORY {
            switch  cate {
            case MOVIE_CATEGORY.GENRE:
                break
            case MOVIE_CATEGORY.TRENDING:
                mPresenter.loadTrendingMovies(isMore: true)
            case MOVIE_CATEGORY.TOP_RATED:
                mPresenter.loadTopRatedMovies(isMore: true)
            case MOVIE_CATEGORY.POPULAR:
                mPresenter.loadPopularMovies(isMore: true)
            case MOVIE_CATEGORY.UPCOMMING:
                mPresenter.loadUpcomingMovies(isMore: true)
            }
        }
    }
}


// MARK:- Conform HomePresenterView Protol
extension HomeViewController: HomePresenterView {
    
    
    func reloadGenres(with data : [GenreModel], _ isMore : Bool) {
        genres = data
        mTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func reloadTrendingMovies(with data : [MovieModel], _ isMore : Bool) {
        trendingMovies = data
        if let cell = mTableView.cellForRow(at: IndexPath(row: 0, section: MOVIE_CATEGORY.TRENDING.rawValue)) as? MovieCategoryTableViewCell , isMore {
            cell.updateData(data)
        } else {
            mTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        
    }
    
    func reloadTopRatedMovies(with data : [MovieModel], _ isMore : Bool) {
        topRatedMovies = data
        if let cell = mTableView.cellForRow(at: IndexPath(row: 0, section: MOVIE_CATEGORY.TOP_RATED.rawValue)) as? MovieCategoryTableViewCell  , isMore{
            cell.updateData(data)
        } else {
            mTableView.reloadRows(at: [IndexPath(row: 0, section: MOVIE_CATEGORY.TOP_RATED.rawValue)], with: .automatic)
        }
    }
    
    func reloadPopularMovies(with data : [MovieModel], _ isMore : Bool) {
        popularMovies = data
        
        if let cell = mTableView.cellForRow(at: IndexPath(row: 0, section: MOVIE_CATEGORY.POPULAR.rawValue)) as? MovieCategoryTableViewCell  , isMore{
            cell.updateData(data)
        } else {
            mTableView.reloadRows(at: [IndexPath(row: 0, section: MOVIE_CATEGORY.POPULAR.rawValue)], with: .automatic)
        }
    }
    
    func reloadUpcomingMovies(with data : [MovieModel] , _ isMore : Bool) {
        upcomingMovies = data
        if let cell = mTableView.cellForRow(at: IndexPath(row: 0, section: MOVIE_CATEGORY.UPCOMMING.rawValue)) as? MovieCategoryTableViewCell , isMore {
            cell.updateData(data)
        } else {
            mTableView.reloadRows(at: [IndexPath(row:0, section: MOVIE_CATEGORY.UPCOMMING.rawValue)], with: .automatic)
        }
    }
    
    func viewMovieDetail(data : Any){
        if let data = data as? MovieModel {
            self.onFocusedMovie = data
            performSegue(withIdentifier: "movieDetailSegue", sender: nil)
        }
    }
    
}

//MARK:- conform Segue protocol
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? MovieDetailViewController {
            ctrl.moviveInfo = onFocusedMovie
        }
    }
}

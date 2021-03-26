import Foundation
protocol HomePresenterView: class {
    func reloadGenres(with data : [GenreModel], _ isMore : Bool)
    func reloadTrendingMovies(with data : [MovieModel],_ isMore : Bool )
    func reloadTopRatedMovies(with data : [MovieModel],_ isMore : Bool )
    func reloadPopularMovies(with data : [MovieModel],_ isMore : Bool )
    func reloadUpcomingMovies(with data : [MovieModel],_ isMore : Bool )
    func viewMovieDetail(data : Any)
}

class HomePresenter {
    weak var view: HomePresenterView?
    var genres : [GenreModel] = []
    var trendingMovies : ( page: Int , total_pages : Int, total_results : Int , data : [MovieModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    var popularMovies : ( page: Int , total_pages : Int, total_results : Int , data : [MovieModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    var topRatedMovies : ( page: Int , total_pages : Int, total_results : Int , data : [MovieModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    var upcomingMovies : ( page: Int , total_pages : Int, total_results : Int , data : [MovieModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    // Pass something that conforms to PresenterView
    init(with view: HomePresenterView) {
        self.view = view
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDetail), name: Notification.Name.init("VIEW_MOVIE_DETAIL"), object: nil)
    }
    
    @objc func viewDetail(data : Notification){
        if let obj = data.object{
            view?.viewMovieDetail(data: obj)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData(){
        loadMovieGenres()
        loadTrendingMovies()
        loadPopularMovies()
        loadTopRatedMovies()
        loadUpcomingMovies()
    }
    
    func forceReloadData(){
        loadData()
    }
    
    func loadMovieGenres(){
        trendingMovies.data.removeAll()
        APICommon.shareInstance().getMovieGenres({[weak self](resp) in
            if let resp = resp{
                let arr = resp["data"] ?? []
                if let arr = arr as? [GenreModel] , let self = self {
                    self.genres.removeAll()
                    self.genres.append(contentsOf: arr)
                    self.view?.reloadGenres(with: self.genres, false)
                }
            }
        })
    }
    
    var isWaitingTrending = false
    var isWaitingTopRated = false
    var isWaitingPopular = false
    var isWaitingUpcoming = false
    func loadTrendingMovies(isMore : Bool = false){
        var nextPage = 1
        if isMore && !isWaitingTrending {
            nextPage = trendingMovies.page + 1
            if nextPage > trendingMovies.total_pages {
                return
            }
        }
        isWaitingTrending = true
        APICommon.shareInstance().getTrendingMovies(page : nextPage ,{[weak self] resp in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                
                if let arr = arr as? [MovieModel], let self = self {
                    
                    if !isMore {
                        self.trendingMovies.data.removeAll()
                    }
                    self.trendingMovies.page = page
                    self.trendingMovies.total_pages = total_pages
                    self.trendingMovies.total_results = total_results
                    self.trendingMovies.data.append(contentsOf: arr)
                    
                    self.view?.reloadTrendingMovies(with: self.trendingMovies.data,isMore)
                    self.isWaitingTrending = false
                }
            }
        },{[weak self] err in
            self?.isWaitingTrending = false
        } )
    }
    
    func loadPopularMovies(isMore : Bool = false){
        var nextPage = 1
        if isMore && !isWaitingPopular {
            nextPage = popularMovies.page + 1
            if nextPage > popularMovies.total_pages {
                return
            }
        }
        isWaitingPopular = true
        APICommon.shareInstance().getPopularMovies(page : nextPage ,{[weak self] resp in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                if let arr = arr as? [MovieModel], let self = self {
                    if !isMore {
                        self.popularMovies.data.removeAll()
                    }
                    self.popularMovies.page = page
                    self.popularMovies.total_pages = total_pages
                    self.popularMovies.total_results = total_results
                    self.popularMovies.data.append(contentsOf: arr)
                    self.view?.reloadPopularMovies(with: self.popularMovies.data, isMore)
                }
            }
        },{[weak self] err in
            self?.isWaitingPopular = false
        } )
        
        
    }
    
    func loadTopRatedMovies(isMore : Bool = false){
        var nextPage = 1
        if isMore && !isWaitingTopRated {
            nextPage = topRatedMovies.page + 1
            if nextPage > topRatedMovies.total_pages {
                return
            }
        }
        isWaitingTopRated = true
        APICommon.shareInstance().getTopRatedMovies(page : nextPage ,{[weak self] resp in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                if let arr = arr as? [MovieModel], let self = self {
                    if !isMore {
                        self.topRatedMovies.data.removeAll()
                    }
                    self.topRatedMovies.page = page
                    self.topRatedMovies.total_pages = total_pages
                    self.topRatedMovies.total_results = total_results
                    self.topRatedMovies.data.append(contentsOf: arr)
                    
                    self.view?.reloadTopRatedMovies(with: self.topRatedMovies.data, isMore)
                }
            }
        },{[weak self] err in
            self?.isWaitingTopRated = false
        } )
    }
    
    func loadUpcomingMovies(isMore : Bool = false){
        
        var nextPage = 1
        if isMore && !isWaitingUpcoming {
            nextPage = upcomingMovies.page + 1
            if nextPage > upcomingMovies.total_pages {
                return
            }
        }
        isWaitingUpcoming = true
        APICommon.shareInstance().getUpcomingMovies(page : nextPage ,{[weak self] resp in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                if let arr = arr as? [MovieModel] , let self = self {
                    if !isMore {
                        self.upcomingMovies.data.removeAll()
                    }
                    self.upcomingMovies.page = page
                    self.upcomingMovies.total_pages = total_pages
                    self.upcomingMovies.total_results = total_results
                    self.upcomingMovies.data.append(contentsOf: arr)
                    self.view?.reloadUpcomingMovies(with: self.upcomingMovies.data, isMore)
                }
            }
        },{[weak self] err in
            self?.isWaitingUpcoming = false
        } )
    }
    
}

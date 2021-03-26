import Foundation

protocol MovieDetailPresenterView: class {
//    func updateLabel()
    func reloadData( movie : MovieDetailModel)
    func reloadSeriesCastSection(_ data : [Codable])
    func reloadVideoFeaturesSection(_ data : [VideoFeatureModel])
    func reloadRecomendationMovies(with data : [MovieModel])
    func reloadMovieReviews(with data : [ReviewModel])
}


class MovieDetailPresenter {
    weak var view: MovieDetailPresenterView?
    var movieDetail : MovieDetailModel?
    var seriesCast : [Codable] = []
    var videoFeatures : [VideoFeatureModel] = []
    var recommendationMovies : ( page: Int , total_pages : Int, total_results : Int , data : [MovieModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    var movieReviews : ( page: Int , total_pages : Int, total_results : Int , data : [ReviewModel]) = (page : 1,  total_pages : 1, total_results : 0 , data : [])
    
    // Pass something that conforms to PresenterView
    init(with view: MovieDetailPresenterView) {
        self.view = view
    }
    
    func loadData(with movieId : String){
        APICommon.shareInstance().getMovieDetail("\(movieId)") {[weak self] (resp) in
            if let resp = resp as? MovieDetailModel , let self = self{
                self.movieDetail = resp
                self.view?.reloadData(movie: resp)
            }
            
        }
        
        self.loadSeriesCast(movieId : movieId)
        self.loadMovieImagesFeature(movieId : movieId)
        self.loadMovieReviews(movieId : movieId)
        self.loadMovieRecommendations(movieId : movieId)
    }
    
    func loadSeriesCast(movieId : String){
        APICommon.shareInstance().getMovieSeriesCast("\(movieId)") {[weak self] (resp) in
            if let resp = resp as? [Codable] , let self = self{
                self.seriesCast = resp
                
                self.view?.reloadSeriesCastSection(resp)
            }
        }
    }
    
    func loadMovieImagesFeature(movieId : String){
        APICommon.shareInstance().getMovieImagesFeature("\(movieId)") {[weak self] (resp) in
            if let resp = resp as? [VideoFeatureModel] , let self = self{
                self.videoFeatures = resp
                
                self.view?.reloadVideoFeaturesSection(resp)
            }
        }
    }
    
    func loadMovieReviews(movieId : String, _ isMore: Bool = false){
        APICommon.shareInstance().getMovieReviews("\(movieId)") {[weak self] (resp) in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                
                if let arr = arr as? [ReviewModel], let self = self {
                    
                    if !isMore {
                        self.movieReviews.data.removeAll()
                    }
                    self.movieReviews.page = page
                    self.movieReviews.total_pages = total_pages
                    self.movieReviews.total_results = total_results
                    self.movieReviews.data.append(contentsOf: arr.reversed())
                    
                    self.view?.reloadMovieReviews(with: self.movieReviews.data)
                }
            }
        }
    }
    
    func loadMovieRecommendations(movieId : String, _ isMore : Bool = false){
        APICommon.shareInstance().getMovieRecommendations("\(movieId)") {[weak self] (resp) in
            if let resp = resp {
                let arr = resp["data"] ?? []
                let page : Int = resp["page"] as! Int
                let total_pages : Int = resp["total_pages"] as! Int
                let total_results : Int = resp["total_results"] as! Int
                
                if let arr = arr as? [MovieModel], let self = self {
                    
                    if !isMore {
                        self.recommendationMovies.data.removeAll()
                    }
                    self.recommendationMovies.page = page
                    self.recommendationMovies.total_pages = total_pages
                    self.recommendationMovies.total_results = total_results
                    self.recommendationMovies.data.append(contentsOf: arr)
                    
                    self.view?.reloadRecomendationMovies(with: self.recommendationMovies.data)
                }
            }
        }
    }
    
}

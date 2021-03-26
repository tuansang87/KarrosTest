//
//  APICommon.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import Foundation
import Alamofire

typealias DataCallback = (_ data : [String : Any]?) -> Void
typealias ErrorCallback = (_ error : Any?) -> Void
typealias RawDataCallback = (_ data : Any?) -> Void

enum API_METHOD : String {
    case GENRE = "genre/movie/list"
    case TRENDING = "trending/all/day"
    case TOP_RATED = "movie/top_rated"
    case POPULAR = "movie/popular"
    case UPCOMMING = "movie/upcoming"
    case MOVIE_DETAIL = "movie"
    
}

enum MOVIE_CATEGORY : Int {
    case GENRE = 0
    case TRENDING = 1
    case TOP_RATED = 2
    case POPULAR = 3
    case UPCOMMING = 4
}

class APICommon {
    private let BASE_URL = "https://api.themoviedb.org/3/"
    private let API_TOKEN = "a7b3c9975791294647265c71224a88ad"
    
    private static var mShareInstance : APICommon?
    static func shareInstance()-> APICommon {
        if let mShareInstance = mShareInstance {
            return mShareInstance
        }
        
        mShareInstance = APICommon()
        return mShareInstance!;
    }
    
    private init(){}
    
    
    func getMovieGenres( _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        // load data from url
        let urlStr = "\(BASE_URL)\(API_METHOD.GENRE.rawValue )?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                            //                            mPrint(jsonObj)
                            if let jsonObject = jsonObj as? [String : Any] {
                                let js = jsonObject["genres"] ?? []
                                let genres =  try JSONDecoder().decode([GenreModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                //                                mPrint(genres)
                                dataCallback(["data": genres])
                            }
                            
                            
                        }
                        
                        
                    } catch let error as NSError {
                        mPrint("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }                
            }
    }
    
    func getTrendingMovies( page : Int = 1 , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        getMoviesByType(type: .POPULAR, page: page, dataCallback, errorCallback)
    }
    
    func getPopularMovies(page : Int = 1 , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        getMoviesByType(type: .POPULAR, page: page, dataCallback, errorCallback)
    }
    
    func getUpcomingMovies( page : Int = 1 , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        getMoviesByType(type: .UPCOMMING, page: page, dataCallback, errorCallback)
    }
    
    func getTopRatedMovies(page : Int = 1 , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        getMoviesByType(type: .TOP_RATED, page: page, dataCallback, errorCallback)
    }
    
    
    
    private func getMoviesByType(type : MOVIE_CATEGORY, page : Int = 1 , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        if type == .GENRE {
            
        } else {
            var apiMethod = ""
            switch type {
            case .POPULAR:
                apiMethod = API_METHOD.POPULAR.rawValue
            case .TOP_RATED:
                apiMethod = API_METHOD.TOP_RATED.rawValue
            case .TRENDING:
                apiMethod = API_METHOD.TRENDING.rawValue
            case .UPCOMMING:
                apiMethod = API_METHOD.UPCOMMING.rawValue
            default:
                apiMethod = ""
            }
            
            let urlStr = "\(BASE_URL)\(apiMethod )?page=\(page)&api_key=\(API_TOKEN)"
            AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
                .responseJSON { response in
                    
                    switch (response.result) {
                    
                    case .success( _):
                        
                        do {
                            if let jsonData = response.data {
                                let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                                mPrint(jsonObj)
                                if let jsonObject = jsonObj as? [String : Any] {
                                    
                                    let js = jsonObject["results"] ?? []
                                    let page : Int = jsonObject["page"] as! Int
                                    let total_pages : Int = jsonObject["total_pages"] as! Int
                                    let total_results : Int = jsonObject["total_results"] as! Int
                                    let results =  try JSONDecoder().decode([MovieModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                    dataCallback(["data": results , "page" : page  , "total_pages" : total_pages , "total_results": total_results])
                                }
                                
                                
                            }
                            
                            
                        } catch let error as NSError {
                            mPrint("Failed to load: \(error.localizedDescription)")
                            errorCallback?(error)
                        }
                        
                    case .failure(let error):
                        mPrint("Request error: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                }
            
        }
        
    }
    
    func getMovieDetail(_ movieId : String, _ dataCallback : @escaping RawDataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        // load data from url
        let urlStr = "\(BASE_URL)\(API_METHOD.MOVIE_DETAIL.rawValue )/\(movieId)?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let detail =  try JSONDecoder().decode(MovieDetailModel.self, from: jsonData)
                            //                            mPrint(detail)
                            dataCallback(detail)
                            
                        }
                        
                        
                    } catch let error as NSError {
                        mPrint("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }
            }
    }
    
    
    func getMovieSeriesCast(_ movieId : String, _ dataCallback : @escaping RawDataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        // load data from url
        
        let urlStr = "\(BASE_URL)\(API_METHOD.MOVIE_DETAIL.rawValue )/\(movieId)/credits?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                            //                            mPrint(jsonObj)
                            if let jsonObject = jsonObj as? [String : Any] {
                                var js = jsonObject["cast"] ?? []
                                let castarr =  try JSONDecoder().decode([CastModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                js = jsonObject["crew"] ?? []
                                let crewarr =  try JSONDecoder().decode([CrewModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                //                                mPrint(arr)
                                var arr : [Codable] = []
                                arr.append(contentsOf: castarr)
                                arr.append(contentsOf: crewarr)
                                dataCallback(arr)
                            }
                            
                            
                        }
                        
                        
                    } catch let error as NSError {
                        mPrint("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }
            }
    }
    
    
    func getMovieImagesFeature(_ movieId : String, _ dataCallback : @escaping RawDataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        // load data from url
        
        let urlStr = "\(BASE_URL)\(API_METHOD.MOVIE_DETAIL.rawValue )/\(movieId)/images?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                            //                            mPrint(jsonObj)
                            if let jsonObject = jsonObj as? [String : Any] {
                                let js = jsonObject["backdrops"] ?? []
                                let arr =  try JSONDecoder().decode([VideoFeatureModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                
                                dataCallback(arr)
                            }
                            
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }
            }
    }
    
    func getMovieReviews(_ movieId : String , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        
        let urlStr = "\(BASE_URL)\(API_METHOD.MOVIE_DETAIL.rawValue )/\(movieId)/reviews?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                            //                                mPrint(jsonObj)
                            if let jsonObject = jsonObj as? [String : Any] {
                                
                                let js = jsonObject["results"] ?? []
                                let page : Int = jsonObject["page"] as! Int
                                let total_pages : Int = jsonObject["total_pages"] as! Int
                                let total_results : Int = jsonObject["total_results"] as! Int
                                let results =  try JSONDecoder().decode([ReviewModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                dataCallback(["data": results , "page" : page  , "total_pages" : total_pages , "total_results": total_results])
                            }
                            
                            
                        }
                        
                        
                    } catch let error as NSError {
                        mPrint("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }
            }
        
    }
    
    
    func getMovieRecommendations(_ movieId : String , _ dataCallback : @escaping DataCallback, _ errorCallback : ErrorCallback? = nil) -> Void {
        
        let urlStr = "\(BASE_URL)\(API_METHOD.MOVIE_DETAIL.rawValue )/\(movieId)/recommendations?api_key=\(API_TOKEN)"
        AF.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                    
                    do {
                        if let jsonData = response.data {
                            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                            //                                print(jsonObj)
                            if let jsonObject = jsonObj as? [String : Any] {
                                
                                let js = jsonObject["results"] ?? []
                                let page : Int = jsonObject["page"] as! Int
                                let total_pages : Int = jsonObject["total_pages"] as! Int
                                let total_results : Int = jsonObject["total_results"] as! Int
                                let results =  try JSONDecoder().decode([MovieModel].self, from: JSONSerialization.data(withJSONObject: js, options: .prettyPrinted))
                                dataCallback(["data": results , "page" : page  , "total_pages" : total_pages , "total_results": total_results])
                            }
                            
                            
                        }
                        
                        
                    } catch let error as NSError {
                        mPrint("Failed to load: \(error.localizedDescription)")
                        errorCallback?(error)
                    }
                    
                case .failure(let error):
                    mPrint("Request error: \(error.localizedDescription)")
                    errorCallback?(error)
                }
            }
        
    }
    
}

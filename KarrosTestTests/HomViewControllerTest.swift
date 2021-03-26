//
//  KarrosTestTests.swift
//  KarrosTestTests
//
//  Created by Sang Huynh on 25/3/21.
//

import XCTest
@testable import KarrosTest

class HomePresenterMock: HomePresenter {
    private(set) var onCalled_loadData = false
    private(set) var onCalled_forceReloadData = false
    private(set) var onCalled_viewDetail = false
    private(set) var onCalled_loadMovieGenres = false
    private(set) var onCalled_loadPopularMovies = false
    private(set) var onCalled_loadTrendingMovies = false
    private(set) var onCalled_loadUpcomingMovies = false
    private(set) var onCalled_loadTopRatedMovies = false
    
    override func loadData() {
        onCalled_loadData = true
        super.loadData()
    }
    
    override func forceReloadData() {
        onCalled_forceReloadData = true
    }
    
    override func viewDetail(data: Notification) {
        onCalled_viewDetail = true
    }
    
    override func loadMovieGenres() {
        onCalled_loadMovieGenres = true
    }
    
    override func loadPopularMovies(isMore: Bool = false) {
        onCalled_loadPopularMovies = true
    }
    
    override func loadTrendingMovies(isMore: Bool = false) {
        onCalled_loadTrendingMovies = true
    }
    
    override func loadUpcomingMovies(isMore: Bool = false) {
        onCalled_loadUpcomingMovies = true
    }
    
    override func loadTopRatedMovies(isMore: Bool = false) {
        onCalled_loadTopRatedMovies = true
    }
}


class HomViewControllerTest: XCTestCase {
    
    var presenter : HomePresenterMock!
    var SUT : HomeViewController!
    
    override func setUp() {
        super.setUp()
        let _ = makeSUT()
    }
    
    func makeSUT() -> HomeViewController {
        presenter = nil
        SUT = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SUT = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        SUT.loadViewIfNeeded()
        presenter = HomePresenterMock(with: SUT)
        SUT.mPresenter = presenter
        return SUT
    }
    
    override func tearDown() {
        presenter = nil
        super.tearDown()
        
    }
   
    
    func testLoadAllDataCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadData)
    }
    
    func testViewMovieDetailCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        do {
            let mMovie = try JSONDecoder().decode(MovieModel.self, from: JSONSerialization.data(withJSONObject: MOVIE_MOCK, options: .prettyPrinted))
            
            NotificationCenter.default.post(name: Notification.Name.init(APP_EVENT.VIEW_MOVIE_DETAIL.rawValue), object: mMovie)
            
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
      
        XCTAssertTrue(presenter.onCalled_viewDetail)
    
    }
    
    func testPullToRefreshCallsPresenter() {
        let sut = makeSUT()
        
        sut.refresh(nil)
        XCTAssertTrue(presenter.onCalled_forceReloadData)
    }
    
    
    
    func testCallLoadMovieGenresCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadMovieGenres)
    }
    
    func testLoadPopularMoviesCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadPopularMovies)
        
    }
    
    func testLoadUpcommingMoviesCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadUpcomingMovies)
    }
    
    func testLoadTrendinMoviesCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadTrendingMovies)
    }
    
    func testLoadTopRatedMoviesCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadTopRatedMovies)
    }
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

let MOVIE_MOCK = [
    "adult": false,
    "backdrop_path": "/egg7KFi18TSQc1s24RMmR9i2zO6.jpg",
    "genre_ids": [
    14,
    28,
    12
    ],
    "vote_count": 4442,
    "original_language": "en",
    "original_title": "Wonder Woman 1984",
    "poster_path": "/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg",
    "video": false,
    "id": 464052,
    "vote_average": 6.8,
    "title": "Wonder Woman 1984",
    "overview": "A botched store robbery places Wonder Woman in a global battle against a powerful and mysterious ancient force that puts her powers in jeopardy.",
    "release_date": "2020-12-16",
    "popularity": 1693.774
] as [String : Any]

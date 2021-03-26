//
//  MovieDetailViewControllerTest.swift
//  KarrosTestTests
//
//  Created by Sang Huynh on 26/3/21.
//

import XCTest

@testable import KarrosTest

class MovieDetailPresenterMock: MovieDetailPresenter {
    private(set) var onCalled_loadData = false
    private(set) var onCalled_loadSeriesCast = false
    private(set) var onCalled_loadMovieImagesFeature = false
    private(set) var onCalled_loadMovieReviews = false
    private(set) var onCalled_loadMovieRecommendations = false
    
    override func loadData(with movieId: String) {
        super.loadData(with: movieId)
        onCalled_loadData = true
    }
    
    override func loadSeriesCast(movieId: String) {
        onCalled_loadSeriesCast = true
    }
    override func loadMovieImagesFeature(movieId: String) {
        onCalled_loadMovieImagesFeature = true
    }
    
    override func loadMovieReviews(movieId: String , _ isMore: Bool = false) {
        onCalled_loadMovieReviews = true
    }
    
    override func loadMovieRecommendations(movieId: String , _ isMore: Bool = false) {
        onCalled_loadMovieRecommendations = true
    }
    
    
}

class MovieDetailViewControllerTest: XCTestCase {

    var presenter : MovieDetailPresenterMock!
    var SUT : MovieDetailViewController!
    
    override func setUp() {
        super.setUp()
        let _ = makeSUT()
    }
    
    func makeSUT() -> MovieDetailViewController {
        presenter = nil
        SUT = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SUT = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        SUT.loadViewIfNeeded()
        presenter = MovieDetailPresenterMock(with: SUT)
        SUT.mPresenter = presenter
        return SUT
    }
    
    func testLoadAllSectionsCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadData)
    }
    
    
    func testCallLoadSeriesCastCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadSeriesCast)
    }
    
    
    func testLoadMovieReviewsCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadMovieReviews)
    }
    
    
    func testLoadMovieImageFeaturesCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadMovieImagesFeature)
    }
    
    
    func testLoadRecommendationCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.onCalled_loadMovieRecommendations)
    }
    
    func testRatingDisplayCorrectWhenUseClickonStarBtn() {
        let sut = makeSUT()
        sut.viewDidLoad()
        if let cell =  sut.mTableView.dequeueReusableCell(withIdentifier: "MovieDetailMyRateTableViewCell") as? MovieDetailMyRateTableViewCell {
            let willRateNo = 5
            let btn = cell.mRatingStars[willRateNo - 1]
            btn.isSelected = false
            cell.didClickOnStarBtn(btn)
            XCTAssertEqual(cell.mRatingNo.text, "\(willRateNo).0")
        }
    }
    
  
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

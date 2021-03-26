import Foundation

struct MovieModel : Codable {
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let poster_path : String?
    let id : Int?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
    let title : String?
    let genre_ids : [Int]?
    let overview : String?
    let release_date : String?
    let popularity : Double?
    let media_type : String?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case original_language = "original_language"
        case original_title = "original_title"
        case poster_path = "poster_path"
        case id = "id"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
        case title = "title"
        case genre_ids = "genre_ids"
        case overview = "overview"
        case release_date = "release_date"
        case popularity = "popularity"
        case media_type = "media_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
        original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
        original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        genre_ids = try values.decodeIfPresent([Int].self, forKey: .genre_ids)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
    }

}

import Alamofire

enum RegisterAPI: BaseTargetType {
    case registerPosts(RegisterRequestDTO)
    case fetchTitles(artistId: Int, keyword: String)
    case fetchArtists(keyword: String)

    var path: String {
        switch self {
        case .registerPosts:
            return "/api/v1/posts"
        case .fetchTitles:
            return "/api/v1/posts/titles"
        case .fetchArtists:
            return "/api/v1/posts/artists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registerPosts:
            return .post
        case .fetchTitles, .fetchArtists:
            return .get
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .fetchTitles(let artistId, let keyword):
            return [
                "artistId": "\(artistId)",
                "keyword": keyword
            ]

        case .fetchArtists(let keyword):
            return ["keyword": keyword]

        case .registerPosts:
            return nil
        }
    }
}

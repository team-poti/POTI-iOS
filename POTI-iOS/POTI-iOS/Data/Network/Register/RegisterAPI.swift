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

    // GET 쿼리 파라미터
    var parameters: Parameters? {
        switch self {
        case .fetchTitles(let artistId, let keyword):
            return ["artistId": artistId, "keyword": keyword]

        case .fetchArtists(let keyword):
            return ["keyword": keyword]

        case .registerPosts:
            return nil
        }
    }

    // POST 바디 파라미터 (BaseTargetType에 bodyParameters가 있다면 그걸 써도 됨)
    var bodyParameters: Parameters? {
        switch self {
        case .registerPosts(let dto):
            return dto.toParameters() // dto -> [String: Any]로
        default:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .fetchTitles, .fetchArtists:
            return URLEncoding.queryString
        case .registerPosts:
            return JSONEncoding.default
        }
    }
}

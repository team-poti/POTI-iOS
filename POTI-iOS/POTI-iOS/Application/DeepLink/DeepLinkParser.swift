//
//  DeepLinkParser.swift
//  POTI-iOS
//
//  Created by soomin on 8/24/26.
//

import Foundation

struct DeepLinkParser {
    
    // MARK: - Property
    
    private let allowedHost: String

    // MARK: - Initializer
    
    init(allowedHost: String) {
        self.allowedHost = allowedHost
    }
    
    // MARK: - Public Method

    func parse(_ url: URL) -> DeepLinkRoute? {
        guard url.scheme?.lowercased() == "https",
              url.host?.lowercased() == allowedHost.lowercased() else { return nil }

        let pathComponents = url.pathComponents.filter { $0 != "/" }
        guard pathComponents.count == 2,
              let id = Int(pathComponents[1]), id > 0 else { return nil }

        switch pathComponents[0] {
        case "pot":
            return .potDetail(postID: id)
        case "participant-detail":
            return .participantDetail(participationID: id)
        case "recruiter-detail":
            return .recruiterDetail(postID: id)
        case "participant-manage":
            return .participantManagement(postID: id)
        default:
            return nil
        }
    }
}

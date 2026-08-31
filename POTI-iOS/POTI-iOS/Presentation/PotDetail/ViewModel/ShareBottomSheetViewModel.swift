//
//  ShareBottomSheetViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import Combine
import Foundation

enum ShareOption {
    case link
    case kakaoTalk
    case x
    case system
}

struct ShareBottomSheetContent {
    let image: String
    let artist: String
    let title: String
    let description: String
    let participantCount: Int
    let totalCount: Int
    let availableMembers: [String]
    let unavailableMembers: [String]
    let host: String
    let potID: Int
    let deepLink: URL

    var templateArgs: [String: String] {
        return [
            "image": image,
            "artist": artist.replacingOccurrences(of: #"\s*\([A-Za-z0-9 .&'-]+\)\s*$"#, with: "", options: .regularExpression),
            "title": title,
            "description": description,
            "participant_count": String(participantCount),
            "total_count": String(totalCount),
            "host": host,
            "pot_id": String(potID),
            "deep_link": deepLink.absoluteString
        ]
    }

    var xShareText: String {
        let artistName = artist.replacingOccurrences(of: #"\s*\([A-Za-z0-9 .&'-]+\)\s*$"#, with: "", options: .regularExpression)
        let availableText = availableMembers.isEmpty ? "없음" : availableMembers.joined(separator: ", ")
        let unavailableText = unavailableMembers.isEmpty ? "없음" : unavailableMembers.joined(separator: ", ")
        let hashtagArtist = artistName.replacingOccurrences(of: " ", with: "")

        return """
        \(title)

        ⭕️ \(availableText)
        ❌ \(unavailableText)

        #포티 #분철 #\(hashtagArtist) @poti_kr
        \(deepLink.absoluteString)
        """
    }
}

final class ShareBottomSheetViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case select(ShareOption)
    }

    // MARK: - Output

    struct Output {
        let selectedOption: AnyPublisher<ShareOption, Never>
    }

    // MARK: - Properties

    let content: ShareBottomSheetContent
    let output: Output

    private let selectedOptionSubject = PassthroughSubject<ShareOption, Never>()

    // MARK: - Initializer

    init(content: ShareBottomSheetContent) {
        self.content = content
        self.output = Output(selectedOption: selectedOptionSubject.eraseToAnyPublisher())
    }

    // MARK: - Methods

    func action(_ trigger: Input) {
        switch trigger {
        case .select(let option):
            selectedOptionSubject.send(option)
        }
    }
}

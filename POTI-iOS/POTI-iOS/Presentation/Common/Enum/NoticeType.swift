//
//  NoticeType.swift
//  POTI-iOS
//
//  Created by soomin on 8/4/26.
//

enum NoticeType {
    case participate
    case register

    var title: String {
        switch self {
        case .participate: "참여자 안내 사항"
        case .register: "모집자 안내 사항"
        }
    }

    var messages: [String] {
        switch self {
        case .participate:
            [
                "모집 완료 후 24시간 이내 입금이 확인되지 않을 경우, 참여는 자동으로 취소되며 이후 서비스 이용에 불이익이 있을 수 있습니다.",
                "입금 후, 모집자가 굿즈를 주문하고 수령하는 과정이 필요하여 배송 시작 상태로 전환되기까지 다소 시간이 소요될 수 있습니다.",
                "마감 기한까지 모집 인원이 과반수 이상 충족되지 않을 경우, 해당 분철팟은 자동으로 종료되며 분철은 진행되지 않습니다."
            ]
        case .register:
            [
                "굿즈 구매 가능 기간을 고려해 분철팟 마감 기간을 설정해주세요.",
                "마감 기간까지 모집 인원이 과반수 이상 충족되지 않을 경우 해당 분철팟은 자동으로 종료되며 분철은 진행되지 않습니다.",
                "분철팟 모집, 굿즈 구매, 배송 및 참여자와의 거래 과정에서 발생하는 사항에 대한 책임은 모집자에게 있습니다."
            ]
        }
    }
}

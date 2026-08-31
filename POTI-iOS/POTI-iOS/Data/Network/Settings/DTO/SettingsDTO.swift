//
//  SettingsDTO.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

struct AccountResponseDTO: Decodable {
    let nickname: String
    let email: String?
    let socialType: String

    func toEntity() -> AccountEntity {
        AccountEntity(nickname: nickname, email: email, socialAccount: socialType.displayName)
    }
}

struct AddressResponseDTO: Decodable, EmptyResponseInitializable {
    let receiverName: String?
    let zipcode: String?
    let address: String?
    let addressDetail: String?
    let phone: String?

    init() {
        receiverName = nil
        zipcode = nil
        address = nil
        addressDetail = nil
        phone = nil
    }

    func toEntity() -> AddressEntity {
        AddressEntity(
            name: receiverName ?? "",
            postalCode: zipcode ?? "",
            address: address ?? "",
            detailAddress: addressDetail ?? "",
            phoneNumber: phone ?? ""
        )
    }
}

private extension String {
    var displayName: String {
        switch uppercased() {
        case "KAKAO": return "카카오톡"
        case "APPLE": return "Apple"
        default: return self
        }
    }
}

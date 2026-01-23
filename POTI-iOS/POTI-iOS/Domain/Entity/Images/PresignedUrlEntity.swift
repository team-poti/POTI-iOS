//
//  PresignedUrlEntity.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

import Foundation

struct PresignedUrlEntity {
    /// S3에 PUT 업로드할 presigned URL
    let uploadUrl: URL
    /// 게시글 POST 시 서버에 전달할 파일 경로
    let fileName: String
}

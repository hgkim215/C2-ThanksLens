//
//  ThanksPolaroid.swift
//  ThanksLens
//
//  Created by 김현기 on 4/17/25.
//

import Foundation
import SwiftData
import SwiftUI

/**
 GalleryView에서 사용하는 폴라로이드 UI에 들어가는 데이터 모델
  - parameters:
    - id: UUID (고유 식별자)
    - createdAt: Date (생성 날짜)
    - modifiedAt: Date (수정 날짜)
    - uploadedImage: Data (업로드한 이미지 데이터)
    - titleText: String (제목)
    - descriptionText: String (설명)
  - methods:
    - getUploadedImage(): Image? (업로드한 이미지를 SwiftUI Image로 변환하여 반환하는 메서드)
 */
@Model
class ThanksPolaroid {
  var id: UUID
  var createdAt: Date
  var modifiedAt: Date
  var uploadedImage: Data
  var titleText: String
  var descriptionText: String

  init(
    id: UUID = UUID(),
    createdAt: Date = Date.now,
    modifiedAt: Date = Date.now,
    uploadedImage: Data,
    titleText: String,
    descriptionText: String
  ) {
    self.id = id
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.uploadedImage = uploadedImage
    self.titleText = titleText
    self.descriptionText = descriptionText
  }
}

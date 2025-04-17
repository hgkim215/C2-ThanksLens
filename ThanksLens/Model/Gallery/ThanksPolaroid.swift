//
//  ThanksPolaroid.swift
//  ThanksLens
//
//  Created by 김현기 on 4/17/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ThanksPolaroid {
  @Attribute(.unique) var id: UUID
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

  func getUploadedImage() -> Image? {
    if let uiImage = UIImage(data: uploadedImage) {
      return Image(uiImage: uiImage)
    }
    return nil
  }
}

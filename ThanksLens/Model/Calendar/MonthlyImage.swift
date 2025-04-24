//
//  MonthlyImage.swift
//  ThanksLens
//
//  Created by 김현기 on 4/24/25.
//

import Foundation
import SwiftData

@Model
class MonthlyImage {
  var id: UUID
  var year: Int
  var month: Int
  var createdAt: Date
  var modifiedAt: Date
  var uploadedImage: Data

  init(
    id: UUID = UUID(),
    year: Int,
    month: Int,
    createdAt: Date = Date.now,
    modifiedAt: Date = Date.now,
    uploadedImage: Data
  ) {
    self.id = id
    self.year = year
    self.month = month
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.uploadedImage = uploadedImage
  }
}

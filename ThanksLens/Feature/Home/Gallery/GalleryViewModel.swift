//
//  GalleryViewModel.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftData
import SwiftUI

/// ObservableObject는 SwiftUI에서 사용되는 프로토콜로, 해당 객체의 상태가 변경될 때 뷰를 자동으로 업데이트합니다.
class GalleryViewModel: ObservableObject {
  /// @Published는 SwiftUI에서 사용되는 프로퍼티 래퍼로, 해당 프로퍼티가 변경될 때마다 뷰를 자동으로 업데이트합니다.
  @Published var selectedDate: Date
  @Published var thanksPolaroids: [ThanksPolaroid] = [
    ThanksPolaroid(uploadedImage: Data(), titleText: "dmdkdkdkdkkd", descriptionText: ""),
    ThanksPolaroid(uploadedImage: Data(), titleText: "dmdkdkdkdkkd", descriptionText: ""),
    ThanksPolaroid(uploadedImage: Data(), titleText: "dmdkdkdkdkkd", descriptionText: ""),
  ]

  init(
    selectedDate: Date = Date.now
  ) {
    self.selectedDate = selectedDate
  }
}

extension GalleryViewModel {
  func formattedDateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
  }

  func updatePolaroids(with newPolaroids: [ThanksPolaroid]) {
    thanksPolaroids = newPolaroids
    print("Update Polaroids Successfully.")
  }
}

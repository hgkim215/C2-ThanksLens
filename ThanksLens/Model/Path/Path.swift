//
//  Path.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import Foundation

class PathModel: ObservableObject {
  // @Published란?
  // @Published는 SwiftUI에서 사용되는 프로퍼티 래퍼로, 해당 프로퍼티가 변경될 때마다 뷰를 자동으로 업데이트합니다.
  @Published var paths: [String] = []

  init(paths: [String] = []) {
    self.paths = paths
  }
}

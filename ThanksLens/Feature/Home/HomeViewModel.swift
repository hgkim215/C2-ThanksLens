//
//  HomeViewModel.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var selectedTab: Tab

  init(selectedTab: Tab = .gallery) {
    self.selectedTab = selectedTab
  }
}

extension HomeViewModel {
  func changeSelectedTab(_ tab: Tab) {
    selectedTab = tab
  }
}

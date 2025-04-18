//
//  HomeViewModel.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var selectedTab: Tab
  @Published var isAddPolaroidModalPresented: Bool

  init(
    selectedTab: Tab = .gallery,
    isAddPolaroidModalPresented: Bool = false
  ) {
    self.selectedTab = selectedTab
    self.isAddPolaroidModalPresented = isAddPolaroidModalPresented
  }
}

extension HomeViewModel {
  func changeSelectedTab(_ tab: Tab) {
    selectedTab = tab
  }
}

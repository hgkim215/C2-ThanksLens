//
//  HomeView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

struct HomeView: View {
  @StateObject private var pathModel = PathModel()
  @StateObject private var homeViewModel = HomeViewModel()

  var body: some View {
    NavigationStack(path: $pathModel.paths) {
      ZStack {
        TabView(selection: $homeViewModel.selectedTab) {
          CalendarView()
        }
      }
    }
    .environmentObject(pathModel)
  }
}

#Preview {
  HomeView()
}

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
            .tabItem {
              Image(
                homeViewModel.selectedTab == .calendar
                  ? "calendarIcon_selected"
                  : "calendarIcon"
              )
            }
            .tag(Tab.calendar)

          GalleryView()
            .tabItem {
              Image(
                homeViewModel.selectedTab == .gallery
                  ? "galleryIcon_selected"
                  : "galleryIcon"
              )
            }
            .tag(Tab.gallery)

          ProfileView()
            .tabItem {
              Image(
                homeViewModel.selectedTab == .profile
                  ? "profileIcon_selected"
                  : "profileIcon"
              )
            }
            .tag(Tab.profile)
        }
        .environmentObject(homeViewModel)

        SeparatorLineView()
      }
    }

    .environmentObject(pathModel)
  }
}

// MARK: - 구분선

private struct SeparatorLineView: View {
  fileprivate var body: some View {
    VStack {
      Spacer()

      Rectangle()
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [Color.customP4, Color.customGray1.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(height: 10)
        .padding(.bottom, 60)
    }
  }
}

#Preview {
  HomeView()
}

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
  @StateObject private var galleryViewModel = GalleryViewModel()

  var body: some View {
    NavigationStack(path: $pathModel.paths) {
      ZStack {
        TabView(selection: $homeViewModel.selectedTab) {
          GalleryView()
            .tabItem {
              Image(
                homeViewModel.selectedTab == .gallery
                  ? "galleryIcon_selected"
                  : "galleryIcon"
              )
            }
            .tag(Tab.gallery)
            .environmentObject(galleryViewModel)

          GalleryView()
            .tabItem {
              Image(
                homeViewModel.selectedTab == .addPolaroid
                  ? "addIcon_selected"
                  : "addIcon"
              )
            }
            .tag(Tab.addPolaroid)
            .environmentObject(galleryViewModel)

          CalendarView()
            .tabItem {
              Image(
                homeViewModel.selectedTab == .calendar
                  ? "calendarIcon_selected"
                  : "calendarIcon"
              )
            }
            .tag(Tab.calendar)
        }
        .environmentObject(homeViewModel)
        .onChange(of: homeViewModel.selectedTab) {
          if homeViewModel.selectedTab == .addPolaroid {
            homeViewModel.isAddPolaroidModalPresented = true
          }
        }
        .sheet(
          isPresented: $homeViewModel.isAddPolaroidModalPresented,
          onDismiss: {
            homeViewModel.selectedTab = .gallery
          }
        ) {
          AddPolaroidView()
        }
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
        .padding(.bottom, 50)
    }
  }
}

#Preview {
  HomeView()
    .environmentObject(GalleryViewModel())
}

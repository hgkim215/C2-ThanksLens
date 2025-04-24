//
//  CalendarView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftData
import SwiftUI

struct CalendarView: View {
  @Environment(\.modelContext) private var modelContext
  @StateObject private var calendarViewModel = CalendarViewModel()

  @State private var isUploadSheetPresented: Bool = false

  var body: some View {
    ZStack {
      Color(Color.customP4)
        .ignoresSafeArea(.all)
      VStack {
        GeometryReader { geometry in
          let width = geometry.size.width
          let imageHeight = width

          if let image = calendarViewModel.selectedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: width, height: imageHeight)
              .clipped()
          } else {
            Image("calendar_image")
              .resizable()
              .scaledToFill()
              .frame(width: width, height: imageHeight)
              .clipped()
          }
        }
        .frame(height: UIScreen.main.bounds.width - 48)
        .background(.black)
        .onAppear {
          calendarViewModel.loadMonthlyImage(context: modelContext)
        }
        .onTapGesture {
          print("Tapped on calendar image")
          isUploadSheetPresented = true
        }
        .sheet(isPresented: $isUploadSheetPresented) {
          UploadMonthlyImageView(calendarViewModel: calendarViewModel)
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.7)])
        }

        ThanksCalendarView(calendarViewModel: calendarViewModel)
          .padding(.top)
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 16)
    }
  }
}

#Preview {
  CalendarView()
}

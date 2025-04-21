//
//  CalendarView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

struct CalendarView: View {
  @State private var selectedDate = Date()
  @State private var selectedImage: UIImage?

  var body: some View {
    ZStack {
      Color(Color.customP4)
        .ignoresSafeArea(.all)
      VStack {
        GeometryReader { geometry in
          let width = geometry.size.width
          let imageHeight = width

          ThanksPhotoPicker(selctedImage: $selectedImage) {
            ZStack {
              if let image = selectedImage {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: width, height: imageHeight)
                  .clipped()
              }
              if selectedImage == nil {
                Image("calendar_image")
                  .frame(width: width, height: imageHeight)
              }
            }
            .overlay(
              Rectangle()
                .stroke(Color.customBlack, lineWidth: 2)
                .blur(radius: 1)
                .offset(x: 0, y: 4)
                .mask(
                  Rectangle()
                    .fill(LinearGradient(
                      colors: [.black.opacity(0.3), .clear],
                      startPoint: .top,
                      endPoint: .bottom
                    ))
                )
            )
          }
        }
        .frame(height: UIScreen.main.bounds.width - 16)
        .ignoresSafeArea(edges: .top)

        DatePicker(
          "날짜를 선택하세요",
          selection: $selectedDate,
          displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .tint(.customP1)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 32)
    }
  }
}

#Preview {
  CalendarView()
}

//
//  GalleryView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

struct GalleryView: View {
  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  let columns = [GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    ZStack {
      Color(Color.customP4)
        .ignoresSafeArea(.all)

      VStack {
        HStack {
          Button(
            action: {
              galleryViewModel.selectedDate = galleryViewModel.selectedDate.addingTimeInterval(-86400)
            },
            label: {
              Image(systemName: "chevron.left")
                .foregroundStyle(.customP1)
            }
          )

          Spacer()

          Text(galleryViewModel.formattedDateString(from: galleryViewModel.selectedDate))
            .font(.PoorStory(size: 24))
            .foregroundStyle(.customP1)

          Spacer()

          Button(
            action: {
              galleryViewModel.selectedDate = galleryViewModel.selectedDate
                .addingTimeInterval(86400)
            },
            label: {
              Image(systemName: "chevron.right")
                .foregroundStyle(.customP1)
            }
          )
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)

        Spacer()

        ScrollView {
          LazyVGrid(columns: columns, spacing: 24) {
            ForEach(galleryViewModel.thanksPolaroids, id: \.self) { polaroid in
              ZStack {
                Color(.customWhite)
                VStack {
                  Image("mock_image")
                    .resizable()
                    .frame(height: 200) // Set the height
                    .aspectRatio(3 / 4, contentMode: .fill)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)

                  Text(polaroid.titleText)
                    .foregroundColor(.customBlack)
                    .font(.Gaegu_Bold(size: 14))
                    .padding(12)
                }
              }
            }
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 32)
        }

        Spacer()
      }
    }
  }
}

extension GalleryView {
  private func emoji(_ value: Int) -> String {
    guard let scalar = UnicodeScalar(value) else { return "?" }
    return String(Character(scalar))
  }
}

#Preview {
  GalleryView()
    .environmentObject(GalleryViewModel())
}

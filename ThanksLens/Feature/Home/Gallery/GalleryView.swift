//
//  GalleryView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

// MARK: - 갤러리뷰 (메인홈탭)

/// 갤러리 화면을 나타내는 뷰로, 상단 날짜 선택 뷰와 폴라로이드 리스트를 포함합니다.
struct GalleryView: View {
  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  let columns = [GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    ZStack {
      Color(Color.customP4)
        .ignoresSafeArea(.all)

      VStack {
        TopDateSelectionView()

        ScrollView {
          LazyVGrid(columns: columns, spacing: 24) {
            ForEach(galleryViewModel.thanksPolaroids, id: \.self) { polaroid in
              PolaroidCell(polaroid: polaroid)
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

// MARK: - 상단 날짜선택뷰

/// 상단에 날짜를 선택할 수 있는 뷰로, 이전/다음 날짜로 이동하는 버튼과 현재 날짜를 표시합니다.
private struct TopDateSelectionView: View {
  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  fileprivate var body: some View {
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
  }
}

// MARK: - 감사폴라로이드셀뷰

/// 개별 폴라로이드 셀을 나타내는 뷰로, 이미지와 제목 텍스트를 포함합니다.
private struct PolaroidCell: View {
  let polaroid: ThanksPolaroid

  fileprivate var body: some View {
    ZStack {
      Color(.customWhite)
        .shadow(color: .customBlack.opacity(0.2), radius: 1, x: 0, y: 4)
      VStack {
        Image("mock_image")
          .resizable()
          .aspectRatio(3 / 4, contentMode: .fit)
          .overlay(
            Rectangle()
              .stroke(Color.customBlack, lineWidth: 2)
              .blur(radius: 1)
              .offset(x: 0, y: 4)
              .mask(
                Rectangle()
                  .fill(LinearGradient(
                    colors: [.black.opacity(0.2), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                  ))
              )
          )
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

#Preview {
  GalleryView()
    .environmentObject(GalleryViewModel())
}

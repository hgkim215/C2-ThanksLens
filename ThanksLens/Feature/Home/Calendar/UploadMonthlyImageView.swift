//
//  UploadMonthlyImageView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/24/25.
//

import SwiftData
import SwiftUI

struct UploadMonthlyImageView: View {
  @Environment(\.modelContext) private var modelContext

  @ObservedObject private var calendarViewModel: CalendarViewModel

  @State private var tempSelectedImage: UIImage?

  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""

  init(calendarViewModel: CalendarViewModel) {
    self.calendarViewModel = calendarViewModel
  }

  var body: some View {
    ZStack {
      Color(.customWhite)
        .ignoresSafeArea(edges: .all)

      VStack {
        CalendarPhotoUploadView(tempSelectedImage: $tempSelectedImage)
          .foregroundStyle(.customP1)

        BottomButtonView(
          context: modelContext,
          calendarViewModel: calendarViewModel,
          tempSelectedImage: $tempSelectedImage,
          showAlert: $showAlert,
          alertMessage: $alertMessage
        )
      }
      .padding(.horizontal, 32)
      .background(.customWhite)
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("허거덩!")
            .font(.PoorStory(size: 20))
            .foregroundStyle(.customP1),

          message: Text(alertMessage)
            .font(.PoorStory(size: 16))
            .foregroundStyle(.customP1),

          dismissButton: .default(Text("확인"))
        )
      }
    }
  }
}

// MARK: - 사진 업로드뷰

private struct CalendarPhotoUploadView: View {
  @Binding var tempSelectedImage: UIImage?

  fileprivate var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let imageHeight = width

      ThanksPhotoPicker(selctedImage: $tempSelectedImage) {
        ZStack {
          if tempSelectedImage == nil {
            Rectangle()
              .fill(.customGray2)
              .frame(width: width, height: imageHeight)

          } else if let image = tempSelectedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: width, height: imageHeight)
              .clipped()
          }
          if tempSelectedImage == nil {
            VStack {
              Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                .frame(width: 32)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
              Text("사진 업로드")
                .font(.PoorStory(size: 18))
            }
            .padding(.top, 16)
            .foregroundStyle(.customP1)
          } else {
            VStack {
              Spacer()
              HStack {
                Spacer()
                Image(systemName: "photo.circle")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32, height: 32)
                  .foregroundStyle(.customWhite)
                  .padding(16)
              }
            }
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
    .frame(height: UIScreen.main.bounds.width)
  }
}

// MARK: - 하단 버튼뷰

private struct BottomButtonView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject private var calendarViewModel: CalendarViewModel

  @Binding var tempSelectedImage: UIImage?

  @Binding var showAlert: Bool
  @Binding var alertMessage: String

  var context: ModelContext

  init(
    context: ModelContext,
    calendarViewModel: CalendarViewModel,
    tempSelectedImage: Binding<UIImage?>,
    showAlert: Binding<Bool>,
    alertMessage: Binding<String>
  ) {
    self.context = context
    self.calendarViewModel = calendarViewModel
    _tempSelectedImage = tempSelectedImage
    _showAlert = showAlert
    _alertMessage = alertMessage
  }

  fileprivate var body: some View {
    HStack {
      CustomCancelButton(
        label: "취소",
        action: {
          dismiss()
        }
      )

      Spacer()

      CustomPrimaryButton(
        label: "업로드",
        logo: "square.and.arrow.up",
        action: {
          if tempSelectedImage == nil {
            alertMessage = "사진을 업로드해주셔야 해요..!"
            showAlert = true
          } else {
            if let imageData = tempSelectedImage?.jpegData(compressionQuality: 0.8) {
              calendarViewModel.saveMonthlyImage(
                context: context,
                imageData: imageData,
                year: calendarViewModel.selectedYear,
                month: calendarViewModel.selectedMonth
              )
              print("Image data: \(imageData)")
              print("Image year: \(calendarViewModel.selectedYear)")
              print("Image month: \(calendarViewModel.selectedMonth)")

              calendarViewModel.loadMonthlyImage(context: context)

              dismiss()
            } else {
              alertMessage = "사진 데이터를 처리하는 데 문제가 발생했어요..!"
              showAlert = true
            }
          }
        }
      )
    }
  }
}

#Preview {
  UploadMonthlyImageView(calendarViewModel: CalendarViewModel())
}

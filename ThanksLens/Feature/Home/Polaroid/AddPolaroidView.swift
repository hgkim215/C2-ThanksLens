//
//  PolaroidAddView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/18/25.
//

import PhotosUI
import SwiftUI

// MARK: - 폴라로이드추가뷰

enum FieldType {
  case title, description
}

struct AddPolaroidView: View {
  @State private var selectedImage: UIImage?
  @State private var titleText: String = ""
  @State private var descriptionText: String = ""

  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""

  var body: some View {
    ScrollView {
      VStack {
        PhotoUploadView(selectedImage: $selectedImage)
          .foregroundStyle(.customP1)

        Spacer(minLength: 32)

        TitleTextFieldView(titleText: $titleText)
          .foregroundStyle(.customP1)

        Spacer(minLength: 32)

        DescriptionTextFieldView(descriptionText: $descriptionText)
          .foregroundStyle(.customP1)

        Spacer(minLength: 48)

        BottomButtonView(
          selectedImage: $selectedImage,
          titleText: $titleText,
          descriptionText: $descriptionText,
          showAlert: $showAlert,
          alertMessage: $alertMessage
        )
        .padding(.bottom, 24)
      }
      .padding(32)
    }
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

// MARK: - 사진 업로드뷰

private struct PhotoUploadView: View {
  @Binding var selectedImage: UIImage?

  fileprivate var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let imageHeight = width * 4 / 3

      ThanksPhotoPicker(selctedImage: $selectedImage) {
        ZStack {
          if selectedImage == nil {
            Rectangle()
              .fill(.customGray2)
              .frame(width: width, height: imageHeight)

          } else if let image = selectedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: width, height: imageHeight)
              .clipped()
          }
          if selectedImage == nil {
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
    .frame(height: UIScreen.main.bounds.width + 32)

    Spacer()
  }
}

// MARK: - 감사 한 줄 텍스트필드뷰

private struct TitleTextFieldView: View {
  @Binding var titleText: String

  fileprivate var body: some View {
    VStack {
      HStack {
        Text("감사 한 줄")
        Spacer()
        Text("\(titleText.count)/25")
      }
      .font(.PoorStory(size: 20))
      .padding(12)

      TextField("당신의 감사를 한 줄로 기록해주세요.", text: $titleText)
        .limitMaxLength(text: $titleText, 25)
        .font(.Gaegu_Regular(size: 16))
        .padding(12)
        .background(.customGray2)
    }
  }
}

// MARK: - 감사 상세 텍스트필드뷰

private struct DescriptionTextFieldView: View {
  @Binding var descriptionText: String

  fileprivate var body: some View {
    VStack {
      HStack {
        Text("감사 상세 내용 (선택)")
        Spacer()
      }
      .font(.PoorStory(size: 20))
      .padding(12)

      TextField("당신의 감사를 상세하게 설명해주세요.", text: $descriptionText, axis: .vertical)
        .lineLimit(4, reservesSpace: true)
        .font(.Gaegu_Regular(size: 16))
        .padding(12)
        .background(.customGray2)
    }
  }
}

// MARK: - 하단 버튼뷰

private struct BottomButtonView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @Binding var selectedImage: UIImage?
  @Binding var titleText: String
  @Binding var descriptionText: String

  @Binding var showAlert: Bool
  @Binding var alertMessage: String

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
        label: "인화",
        logo: "camera.viewfinder",
        action: {
          if selectedImage == nil {
            alertMessage = "사진을 업로드해주셔야 해요..!"
            showAlert = true
          } else if titleText.isEmpty {
            alertMessage = "감사 한 줄을 입력해주셔야 해요..!"
            showAlert = true
          } else {
            let polaroid = ThanksPolaroid(
              uploadedImage: selectedImage!.jpegData(compressionQuality: 0.8)!,
              titleText: titleText,
              descriptionText: descriptionText
            )

            modelContext.insert(polaroid)
            try! modelContext.save()

            dismiss()
          }
        }
      )
    }
  }
}

#Preview {
  AddPolaroidView()
}

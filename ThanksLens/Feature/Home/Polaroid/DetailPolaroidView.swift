//
//  DetailPolaroidView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/21/25.
//

import SwiftData
import SwiftUI

struct DetailPolaroidView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  @State private var tempPolaroid: ThanksPolaroid?

  @State private var selectedImage: UIImage?
  @State private var titleText: String = ""
  @State private var descriptionText: String = ""

  @State private var isEditMode: Bool = false

  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Text(galleryViewModel.formattedDateString(
            from: galleryViewModel.selectedPolaroid!.createdAt,
            isDetailView: true
          ))
          .font(.PoorStory(size: 20))
          .foregroundStyle(.customP1)

          Spacer()

          if isEditMode {
            Button(
              action: {
                isEditMode = false
                dismiss()
              },
              label: {
                Text("취소")
                  .foregroundStyle(.customP1)
              }
            )

          } else {
            Menu {
              Button(
                action: {
                  isEditMode = true
                  print("수정모드")
                },
                label: {
                  Label("수정", systemImage: "pencil")
                }
              )
              Button(
                role: .destructive,
                action: {
                  modelContext.delete(galleryViewModel.selectedPolaroid!)
                  try! modelContext.save()
                  dismiss()
                },
                label: {
                  Label("삭제", systemImage: "trash")
                }
              )
            } label: {
              Image(systemName: "ellipsis")
                .foregroundStyle(.customP1)
            }
          }
        }
        .padding(.vertical, 16)

        PhotoUploadView(selectedImage: $selectedImage, isEditMode: $isEditMode)
          .onAppear {
            selectedImage = UIImage(data: galleryViewModel.selectedPolaroid!.uploadedImage)
          }
          .foregroundStyle(.customP1)

        Spacer(minLength: 32)

        TitleTextFieldView(titleText: $titleText, isEditMode: $isEditMode)
          .onAppear {
            titleText = galleryViewModel.selectedPolaroid?.titleText ?? ""
          }
          .foregroundStyle(.customP1)

        Spacer(minLength: 32)

        DescriptionTextFieldView(descriptionText: $descriptionText, isEditMode: $isEditMode)
          .onAppear {
            descriptionText = galleryViewModel.selectedPolaroid?.descriptionText ?? ""
          }
          .foregroundStyle(.customP1)
          .padding(.bottom, 24)

        if isEditMode {
          Spacer(minLength: 24)

          BottomButtonView(
            selectedImage: $selectedImage,
            titleText: $titleText,
            descriptionText: $descriptionText,
            showAlert: $showAlert,
            alertMessage: $alertMessage
          )
          .padding(.bottom, 24)
        }
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
  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  @Binding var selectedImage: UIImage?
  @Binding var isEditMode: Bool

  fileprivate var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let imageHeight = width * 4 / 3

      ThanksPhotoPicker(selctedImage: $selectedImage, isEditMode: $isEditMode) {
        ZStack {
          if let image = selectedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: width, height: imageHeight)
              .clipped()
          }

          if isEditMode {
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
    .frame(height: UIScreen.main.bounds.width + 32)

    Spacer()
  }
}

// MARK: - 감사 한 줄 텍스트필드뷰

private struct TitleTextFieldView: View {
  @Binding var titleText: String
  @Binding var isEditMode: Bool

  fileprivate var body: some View {
    VStack {
      HStack {
        Text("감사 한 줄")
        Spacer()
        if isEditMode {
          Text("\(titleText.count)/25")
        }
      }
      .font(.PoorStory(size: 20))
      .padding(12)

      TextField("당신의 감사를 한 줄로 기록해주세요.", text: $titleText)
        .limitMaxLength(text: $titleText, 25)
        .font(.Gaegu_Regular(size: 16))
        .padding(12)
        .background(.customGray2)
        .disabled(!isEditMode)
    }
  }
}

// MARK: - 감사 상세 텍스트필드뷰

private struct DescriptionTextFieldView: View {
  @Binding var descriptionText: String
  @Binding var isEditMode: Bool

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
        .disabled(!isEditMode)
    }
  }
}

// MARK: - 하단 버튼뷰

private struct BottomButtonView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @EnvironmentObject private var galleryViewModel: GalleryViewModel

  @Binding var selectedImage: UIImage?
  @Binding var titleText: String
  @Binding var descriptionText: String

  @Binding var showAlert: Bool
  @Binding var alertMessage: String

  fileprivate var body: some View {
    CustomPrimaryButton(
      label: "수정",
      logo: "pencil",
      width: UIScreen.main.bounds.width - 64,
      action: {
        if selectedImage == nil {
          alertMessage = "사진을 업로드해주셔야 해요..!"
          showAlert = true
        } else if titleText.isEmpty {
          alertMessage = "감사 한 줄을 입력해주셔야 해요..!"
          showAlert = true
        } else {
          galleryViewModel.selectedPolaroid?.titleText = titleText
          galleryViewModel.selectedPolaroid?.descriptionText = descriptionText
          galleryViewModel.selectedPolaroid?.uploadedImage = selectedImage!.jpegData(compressionQuality: 1)!
          galleryViewModel.selectedPolaroid?.modifiedAt = Date.now

          try! modelContext.save()
          dismiss()
        }
      }
    )
  }
}

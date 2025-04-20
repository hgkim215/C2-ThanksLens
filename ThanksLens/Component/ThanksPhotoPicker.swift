//
//  ThanksPhotoPicker.swift
//  ThanksLens
//
//  Created by 김현기 on 4/20/25.
//

import PhotosUI
import SwiftUI

/**
  사진 추가 시 사용하는 커스텀 PhotoPicker입니다.

  - Parameters:
    - selectedPhoto: PhotoPicker와 상호 연동할 수 있는 선택된 Item 상태 프로퍼티
    - selctedImage: 실제 해당 컴포넌트를 호출한 상위 뷰와 바인딩 시킬 Image 프로퍼티
    - isPresentedError: 로드 중 실패 시 상위 뷰에 에러를 띄워주기 위해 감지하는 바인딩 프로퍼티
    - matching: 어떤 종류의 사진을 선택할 것인지 설정하는 필터 타입 프로퍼티
    - photoLibrary: 사진 라이브러리 접근을 위한 PHPhotoLibrary 타입의 인스턴스 변수
    - content: 제네릭하게 받아온 View
 */
public struct ThanksPhotoPicker<Content: View>: View {
  @State private var selectedPhoto: PhotosPickerItem?
  @Binding private var selctedImage: UIImage?
  @Binding private var isPresentedError: Bool
  private let matching: PHPickerFilter
  private let photoLibrary: PHPhotoLibrary
  private let content: () -> Content

  public init(
    selectedPhoto: PhotosPickerItem = PhotosPickerItem(itemIdentifier: ""),
    selctedImage: Binding<UIImage?>,
    isPresentedError: Binding<Bool> = .constant(false),
    matching: PHPickerFilter = .images,
    photoLibrary: PHPhotoLibrary = .shared(),
    content: @escaping () -> Content
  ) {
    self.selectedPhoto = selectedPhoto
    _selctedImage = selctedImage
    _isPresentedError = isPresentedError
    self.matching = matching
    self.photoLibrary = photoLibrary
    self.content = content
  }

  public var body: some View {
    PhotosPicker(
      selection: $selectedPhoto,
      matching: matching,
      photoLibrary: photoLibrary
    ) {
      content()
    }
    .onChange(of: selectedPhoto) {
      handleSelectedPhoto(selectedPhoto)
    }
  }
}

extension ThanksPhotoPicker {
  private func handleSelectedPhoto(_ photo: PhotosPickerItem?) {
    photo?.loadTransferable(type: Data.self) { result in
      switch result {
      case let .success(data):
        if let data = data, let loadedImage = UIImage(data: data) {
          DispatchQueue.main.async {
            self.selctedImage = loadedImage
          }
          print("Image loaded successfully")
        }

      case .failure:
        isPresentedError = true
        print("Failed to load image")
      }
    }
  }
}

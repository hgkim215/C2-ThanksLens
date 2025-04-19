//
//  AddPolaroidViewModel.swift
//  ThanksLens
//
//  Created by 김현기 on 4/19/25.
//

import PhotosUI
import SwiftUI

class AddPolarioidViewModel: ObservableObject {
  @Published var selectImage: PhotosPickerItem?

  init(
    selectImage: PhotosPickerItem? = nil
  ) {
    self.selectImage = selectImage
  }
}

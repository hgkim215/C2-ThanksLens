//
//  GalleryView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

struct GalleryView: View {
  var body: some View {
    ZStack {
      Color(Color.customP4)
        .ignoresSafeArea(.all)

      VStack {
        Image("mock_image")
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 400)
      }
    }
  }
}

#Preview {
  GalleryView()
}

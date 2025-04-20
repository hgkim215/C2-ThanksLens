//
//  MaxLengthModifier.swift
//  ThanksLens
//
//  Created by 김현기 on 4/19/25.
//

import SwiftUI

struct MaxLengthModifier: ViewModifier {
  @Binding var text: String
  let maxLength: Int

  func body(content: Content) -> some View {
    content
      .onChange(of: text) { oldValue, newValue in
        if newValue.count > maxLength {
          text = oldValue
        }
      }
  }
}

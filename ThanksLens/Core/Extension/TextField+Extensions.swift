//
//  TextField+Extensions.swift
//  ThanksLens
//
//  Created by 김현기 on 4/19/25.
//

import SwiftUI

extension TextField {
  func limitMaxLength(text: Binding<String>, _ maxLength: Int) -> some View {
    return ModifiedContent(
      content: self,
      modifier: MaxLengthModifier(
        text: text,
        maxLength: maxLength
      )
    )
  }
}

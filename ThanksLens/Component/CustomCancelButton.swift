//
//  CustomCancelButton.swift
//  ThanksLens
//
//  Created by 김현기 on 4/20/25.
//

import SwiftUI

struct CustomCancelButton: View {
  let label: String
  let action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: {
        Text(label)
      }
    )
    .frame(width: 160, height: 70)
    .foregroundStyle(.customP1)
    .background(.customWhite)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(.customP2, lineWidth: 2)
    )
    .cornerRadius(10)
  }
}

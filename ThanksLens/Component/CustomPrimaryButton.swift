//
//  CustomPrimaryButton.swift
//  ThanksLens
//
//  Created by 김현기 on 4/20/25.
//

import SwiftUI

struct CustomPrimaryButton: View {
  let label: String
  let logo: String
  let width: CGFloat
  let action: () -> Void

  init(label: String, logo: String, width: CGFloat = 160, action: @escaping () -> Void) {
    self.label = label
    self.logo = logo
    self.width = width
    self.action = action
  }

  var body: some View {
    Button(
      action: action,
      label: {
        Label(label, systemImage: logo)
      }
    )
    .frame(width: width, height: 70)
    .foregroundStyle(.customWhite)
    .background(.customP2)
    .cornerRadius(10)
  }
}

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
  let action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: {
        Label(label, systemImage: logo)
      }
    )
    .frame(width: 160, height: 70)
    .foregroundStyle(.customWhite)
    .background(.customP2)
    .cornerRadius(10)
  }
}

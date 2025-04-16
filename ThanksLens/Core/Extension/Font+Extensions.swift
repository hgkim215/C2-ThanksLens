//
//  Font+Extensions.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

extension Font {
  static func BMHANNAPro(size: CGFloat) -> Font {
    return Font.custom("BMHANNAPro", size: size)
  }

  static func BMHANNAPro(style: UIFont.TextStyle) -> Font {
    let font = UIFont(name: "BMHANNAPro", size: UIFont.preferredFont(forTextStyle: style).pointSize) ?? UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize)
    return Font(font as CTFont)
  }
}

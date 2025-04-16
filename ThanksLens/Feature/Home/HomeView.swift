//
//  HomeView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftUI

struct HomeView: View {
  @StateObject private var pathModel = PathModel()

  var body: some View {
    NavigationStack(path: $pathModel.paths) {
      Text("zz")
    }
  }
}

#Preview {
  HomeView()
}

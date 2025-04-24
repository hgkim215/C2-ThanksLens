//
//  ThanksLensApp.swift
//  ThanksLens
//
//  Created by 김현기 on 4/14/25.
//

import SwiftData
import SwiftUI

@main
struct ThanksLensApp: App {
  var body: some Scene {
    WindowGroup {
      HomeView()
        .modelContainer(for: [ThanksPolaroid.self, MonthlyImage.self])
    }
  }
}

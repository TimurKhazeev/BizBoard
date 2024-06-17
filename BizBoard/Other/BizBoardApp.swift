//
//  BizBoardApp.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 19.05.2024.
//

import SwiftUI
import FirebaseCore

@main
struct BizBoardApp: App {
  init() {
    FirebaseApp.configure()
  }
  
    var body: some Scene {
        WindowGroup {
          ScreensaverView()
        }
    }
}

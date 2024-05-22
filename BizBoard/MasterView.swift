//
//  MasterView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import SwiftUI

struct MasterView: View {
  
  private let userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
    var body: some View {
        Text("Главный экран")
    }
}

#Preview {
  MasterView(userId: "")
}

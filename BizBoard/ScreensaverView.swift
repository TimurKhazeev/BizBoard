//
//  ScreensaverView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 22.05.2024.
//
// Заставка

import SwiftUI

/// Этот класс представляет экран заставки приложения.
/// Он отображает анимированный логотип до активации основного представления.
struct ScreensaverView: View {
  
  @State private var isActiv = false
  @State private var size = 0.8
  @State private var opacity = 0.5
  
  var body: some View {
    if isActiv {
      MainView()
    } else {
      
      VStack {
        VStack {
          Image("logoBlue")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 350, height: 350)
          
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear() {
          withAnimation(.easeIn(duration: 1.2)) {
            self.size = 0.9
            self.opacity = 1.0
          }
        }
        
      }
      .onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          withAnimation() {
            self.isActiv = true
          }
        }
      }
      
    }
    
  }
}

#Preview {
  ScreensaverView()
}

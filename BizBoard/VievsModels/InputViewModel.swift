//
//  InputViewModel.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//
// Логика страницы входа

import Foundation
import FirebaseAuth
import SwiftUI

class InputViewModel: ObservableObject {
  
  @Published var mail = ""
  @Published var password = ""
  @Published var errorMessage = ""
  
  init() {}
  
  func login() {
    guard validate() else {
      return
    }
    
    // Отправка запроса на апи для входа
    Auth.auth().signIn(withEmail: mail, password: password)
  }
  
  private func validate() -> Bool {
    errorMessage = ""
    guard !mail.trimmingCharacters(in: .whitespaces).isEmpty,
          !password.trimmingCharacters(in: .whitespaces).isEmpty else {
      errorMessage = "Fill in all the fields"
      return false
    }
    
    guard mail.contains("@") && mail.contains(".") else {
      errorMessage = "Enter the correct Email"
      return false
    }
    
    return true
  }
  
}

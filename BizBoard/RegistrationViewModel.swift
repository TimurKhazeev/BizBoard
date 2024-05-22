//
//  RegistrationViewModel.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//
// Логика страницы регистрации

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewModel: ObservableObject {
  
  @Published var name = ""
  @Published var mail = ""
  @Published var password = ""
  @Published var passwordRepeat = ""
  @Published var errorMessage = ""
  
  init() {}
  
  func registration() {
    guard validate() else {
      return
    }
    
    // Отправка запроса на апи для регистрации
    Auth.auth().createUser(withEmail: mail, password: password) {
      [weak self]  result, error in
      guard let userID = result?.user.uid else {
        return
      }
      
      self?.inertUserRecord(id: userID)
    }
  }
  
  private func inertUserRecord(id: String) {
      let newUser = User(id: id,
                         name: name,
                         mail: mail)
      
      let db = Firestore.firestore()
      
      db.collection("users")
        .document(id)
        .setData(newUser.asDictionary())
      
  }
  
  // Функция проверки на коректность ввода данных
  private func validate() -> Bool {
    
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
          !mail.trimmingCharacters(in: .whitespaces).isEmpty,
          !password.trimmingCharacters(in: .whitespaces).isEmpty,
          !passwordRepeat.trimmingCharacters(in: .whitespaces).isEmpty else {
      errorMessage = "Fill in all the fields"
      return false
    }
    
    guard mail.contains("@") && mail.contains(".") else {
      errorMessage = "Enter the correct Email"
      return false
    }
    
    guard password.count >= 6 else {
      errorMessage = "The password must be longer than 6 characters"
      return false
    }
    
    guard password == passwordRepeat else {
      errorMessage = "Enter identical passwords"
      return false
    }
    
    return true
  }
  
}

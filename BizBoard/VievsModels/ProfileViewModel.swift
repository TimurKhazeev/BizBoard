//
//  ProfileViewModel.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 24.05.2024.
//

import Foundation
import FirebaseFirestore
import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
  init() {}
  
  @Published var user: User? = nil
  
  func fetchUser() {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }
    
    let db = Firestore.firestore()
    db.collection("users").document(userId).getDocument {[weak self] snapshot, error in
      guard let data = snapshot?.data(), error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self?.user = User(
          id: data["id"] as? String ?? "",
          name: data["name"] as? String ?? "",
          mail: data["mail"] as? String ?? ""
        )
      }
    }
  }
  
  func logOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error)
    }
  }
}

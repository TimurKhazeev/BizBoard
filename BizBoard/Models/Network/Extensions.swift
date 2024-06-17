//
//  Extensions.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 22.11.2023.
//

import Foundation

extension Encodable {
  func asDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self) else {
      return [:]
    }
    
    do {
      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
      return json ?? [:]
    } catch {
      return [:]
    }
  }
}

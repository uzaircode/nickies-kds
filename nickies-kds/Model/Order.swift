//
//  Order.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import Foundation

struct Order: Codable, Identifiable {
  var id: Int?
  var createdAt: Date = Date()
  var productId: UUID
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case createdAt = "created_at"
    case productId = "product_id"
  }
}

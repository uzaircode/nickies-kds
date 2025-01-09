//
//  OrderItems.swift
//  nickies-kds
//
//  Created by Nik Uzair on 07/11/2024.
//

import Foundation

struct OrderItems: Codable, Identifiable {
  var id: Int?
  var orderId: Int
  var productId: Int
  var amount: Int
  
  private enum CodingKeys: String, CodingKey {
    case id
    case orderId = "order_id"
    case productId = "product_id"
    case amount
  }
}

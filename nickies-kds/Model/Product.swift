//
//  Product.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import Foundation

struct Product: Codable, Identifiable {
  var id: Int
  let name: String
  let price: Double
}

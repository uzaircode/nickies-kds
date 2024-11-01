//
//  OrderListView.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import SwiftUI

struct OrderListView: View {
  @State var orderList: [Order]
  
  var body: some View {
    VStack {
      ForEach(orderList) { list in
        OrderCard(orderView: list) { orderId in
          if let index = orderList.firstIndex(where: { $0.id == orderId }) {
            orderList.remove(at: index)
          }
        }
      }
      .padding(.bottom)
    }
  }
}

#Preview {
  let productID1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
  let productID2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
  
  OrderListView(orderList: [
    Order(id: 1, productId: productID1),
    Order(id: 2, productId: productID2)
  ])
  .environment(\.supabaseClient, .development)
}

//
//  OrderView.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import SwiftUI

struct OrderView: View {
  let orderView: Order
  @Environment(\.supabaseClient) private var supabaseClient
  let onDone: (Int) -> Void // Closure to notify when done
  
  private func safeOrder() async {
    guard let orderId = orderView.id else {
      print("Order ID is missing")
      return
    }
    
    let updatedText = "done"
    
    do {
      try await supabaseClient
        .from("orders")
        .update(["text": updatedText])
        .eq("id", value: orderId)
        .execute()
      
      // Call the closure to remove the order after updating
      onDone(orderId) // Notify that the order is done
    } catch {
      print("Failed to update order:", error)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(orderView.productId.uuidString)
        .font(.headline)
        .foregroundColor(.primary)
      
      if let orderId = orderView.id {
        Text("Order ID: \(orderId)")
          .font(.subheadline)
          .foregroundColor(.secondary)
      } else {
        Text("Order ID: Unavailable")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      
      Button(action: {
        Task {
          await safeOrder()
        }
      }) {
        Text("Done")
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
      }
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .shadow(radius: 1))
    .padding(.horizontal)
  }
}


#Preview {
    let productID1 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

    OrderListView(orderList: [
        Order(id: 1, productId: productID1)
    ])
    .environment(\.supabaseClient, .development)
}

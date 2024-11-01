//
//  HomeScreen.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import SwiftUI
import Supabase

struct HomeScreen: View {
  
  @Environment(\.supabaseClient) private var supabaseClient
  @State private var listOrder: [Order] = []
  
  private func configureChannelSubscription() async {
    let channel =  supabaseClient.channel("general")
    
    let changeStream = channel.postgresChange(
      AnyAction.self,
      schema: "public",
      table: "orders"
    )
    
    await channel.subscribe()
    
    for await change in changeStream {
      switch change {
      case .delete(let action): print("Deleted: \(action.oldRecord)")
      case .insert(let action): await handleInsertOrder(action.record)
      case .update(let action): await {
        print("Updated: \(action.oldRecord) with \(action.record)")
        await handleUpdateOrder(action.record)
      }()
      }
    }
  }
  
  private func loadOrder() async throws {
    listOrder = try await supabaseClient
      .from("orders")
      .select()
      .execute()
      .value
    
    print(listOrder)
  }
  
  private func handleInsertOrder(_ record: [String: AnyJSON]) async {
    guard let id = record["id"]?.intValue,
          let productIdString = record["product_id"]?.stringValue,
          let productId = UUID(uuidString: productIdString)
    else {
      print("error")
      return
    }
    
    let order = Order(id: id, productId: productId)
    listOrder.append(order)
  }
  
  private func handleUpdateOrder(_ record: [String: AnyJSON]) async {
    guard let id = record["id"]?.intValue,
          let productIdString = record["productId"]?.stringValue,
          let productId = UUID(uuidString: productIdString)
    else {
      print("error")
      return
    }
    
    if let index = listOrder.firstIndex(where: { $0.id == id }) {
      listOrder[index].productId = productId
      listOrder = listOrder
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        ScrollView {
          LazyVStack {
            ForEach(listOrder, id: \.id) { order in
              OrderCard(orderView: order) { orderId in
                if let index = listOrder.firstIndex(where: { $0.id == orderId }) {
                  listOrder.remove(at: index)
                }
              }
            }
            .padding(.bottom)
          }
          .padding(.vertical)
        }
      }
      .navigationTitle("Nickies KDS")
    }
    .task {
      do {
        try await loadOrder()
        await configureChannelSubscription()
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  HomeScreen()
    .environment(\.supabaseClient, .development)
}

import SwiftUI
import Supabase

struct HomeScreen: View {
  @Environment(\.supabaseClient) private var supabaseClient
  @State private var orders: [OrderItems] = []
  @State private var products: [Product] = []
  @State private var errorMessage: String? = nil
  
  private func loadProducts() async {
    do {
      products = try await supabaseClient
        .from("products")
        .select()
        .execute()
        .value
    } catch {
      errorMessage = "Failed to load products: \(error.localizedDescription)"
      print(errorMessage ?? "Unknown error")
    }
  }
  
  private func handleInsertOrder(_ record: [String: AnyJSON]) async {
    guard let orderId = record["order_id"]?.intValue,
          let productId = record["product_id"]?.intValue,
          let amount = record["amount"]?.intValue
    else { return }
    
    let order = OrderItems(orderId: orderId, productId: productId, amount: amount)
    orders.append(order)
  }
  
  private func configureChannelSubscription() async {
    let channel = supabaseClient.channel("general")
    let changeStream = channel.postgresChange(
      AnyAction.self,
      schema: "public",
      table: "order_items"
    )
    await channel.subscribe()
    for await change in changeStream {
      switch change {
      case .delete(let action):
        print("delete \(action)")
      case .insert(let action):
        await handleInsertOrder(action.record)
      case .update(let action):
        print("update \(action)")
      }
    }
  }
  
  private func loadOrders() async {
    do {
      orders = try await supabaseClient
        .from("order_items")
        .select()
        .execute()
        .value
    } catch {
      errorMessage = "Failed to load orders: \(error.localizedDescription)"
    }
  }
  
  private func getProductName(for productId: Int) -> String? {
    return products.first(where: { $0.id == productId })?.name
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if let errorMessage = errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .padding()
        }
        
        ScrollView {
          LazyVStack {
            // Group orders by orderId once outside the ForEach
            let groupedOrders = Dictionary(grouping: orders, by: { $0.orderId })
            ForEach(groupedOrders.keys.sorted(), id: \.self) { orderId in
              if let orderGroup = groupedOrders[orderId] {
                OrderCardView(orderId: orderId, orderGroup: orderGroup, getProductName: getProductName, orders: $orders)
              }
            }
          }
          .padding(.vertical)
        }
      }
      .navigationTitle("Nickies KDS")
    }
    .task {
      await loadOrders()
      await loadProducts()
      await configureChannelSubscription()
    }
  }
}

@ViewBuilder
private func OrderCardView(orderId: Int, orderGroup: [OrderItems], getProductName: @escaping (Int) -> String?, orders: Binding<[OrderItems]>) -> some View {
  VStack(alignment: .leading) {
    Text("Order ID: \(orderId)")
      .font(.caption)
      .padding(.bottom, 2)
      .foregroundColor(.black)
    
    ForEach(orderGroup, id: \.id) { order in
      if let productName = getProductName(order.productId) {
        HStack {
          Text("\(productName)")
            .font(.title3)
            .foregroundColor(.black)
          Spacer()
          Text("x\(order.amount)")
            .font(.title3)
            .foregroundColor(.black)
        }
        .padding(.vertical, 2)
      } else {
        Text("Product not found for Order ID: \(orderId)")
          .foregroundColor(.gray)
      }
    }
    
    Button(action: {
      orders.wrappedValue.removeAll(where: { $0.orderId == orderId })
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
  .frame(maxWidth: .infinity)
  .background(Color.white)
  .cornerRadius(12)
  .shadow(radius: 8)
  .padding(.horizontal)
  .padding(.bottom, 10)
}

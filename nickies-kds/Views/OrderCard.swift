import SwiftUI
import Supabase

struct OrderCard: View {
  let orderId: Int  // Only the order ID is needed now
  let onDone: (Int) -> Void  // Closure to handle the "Done" button action
  
  @Environment(\.supabaseClient) private var supabaseClient
  @State private var orderItems: [OrderItems] = []
  @State private var products: [Product] = []
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(orderItems, id: \.id) { orderItem in
        if let product = products.first(where: { $0.id == orderItem.productId }) {
          HStack {
            Text(product.name)
              .font(.headline)
          }
          .padding(.vertical, 4)
        } else {
          Text("Product not found")
            .font(.headline)
            .foregroundColor(.red)
        }
      }
    }
    Button(action: {
    }) {
      Text("Done")
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    .padding(.top, 8)
    .background(RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .shadow(radius: 1))
  }
}

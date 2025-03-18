//
//  ContentView.swift
//  OnlineFoodOrder
//
//  Created by Mohar on 17/03/25.
//

import SwiftUI

// Model for Food Item
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let image: String
}

// Sample Data
let sampleFoods = [
    FoodItem(name: "Burger", price: 5.99, image: "burger"),
    FoodItem(name: "Pizza", price: 7.99, image: "pizza"),
    FoodItem(name: "Sushi", price: 12.99, image: "sushi"),
    FoodItem(name: "Pasta", price: 8.99, image: "pasta")
]

// ViewModel for Cart
class CartViewModel: ObservableObject {
    @Published var cartItems: [FoodItem] = []
    @Published var orders: [[FoodItem]] = []
    
    func addToCart(_ item: FoodItem) {
        cartItems.append(item)
    }
    
    func removeFromCart(at index: Int) {
        cartItems.remove(at: index)
    }
    
    func checkout() {
        if !cartItems.isEmpty {
            orders.append(cartItems)
            cartItems.removeAll()
        }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
}

// Main View
struct ContentView: View {
    @StateObject var cartVM = CartViewModel()
    
    var body: some View {
        NavigationView {
            List(sampleFoods) { food in
                NavigationLink(destination: FoodDetailView(food: food, cartVM: cartVM)) {
                    HStack {
                        Image(food.image)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(food.name)
                                .font(.headline)
                            Text("$\(food.price, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Food Menu")
            .toolbar {
                HStack {
                    NavigationLink(destination: CartView(cartVM: cartVM)) {
                        Image(systemName: "cart")
                    }
                    NavigationLink(destination: OrdersView(cartVM: cartVM)) {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
    }
}

// Detail View
struct FoodDetailView: View {
    let food: FoodItem
    @ObservedObject var cartVM: CartViewModel
    
    var body: some View {
        VStack {
            Image(food.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(12)
            
            Text(food.name)
                .font(.largeTitle)
                .padding()
            
            Text("Price: $\(food.price, specifier: "%.2f")")
                .font(.title2)
            
            Button(action: {
                cartVM.addToCart(food)
            }) {
                Text("Add to Cart")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationTitle(food.name)
    }
}

// Cart View
struct CartView: View {
    @ObservedObject var cartVM: CartViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(cartVM.cartItems.indices, id: \ .self) { index in
                    HStack {
                        Text(cartVM.cartItems[index].name)
                        Spacer()
                        Text("$\(cartVM.cartItems[index].price, specifier: "%.2f")")
                    }
                }
                .onDelete { indexSet in
                    cartVM.removeFromCart(at: indexSet.first!)
                }
            }
            
            Text("Total: $\(cartVM.totalPrice, specifier: "%.2f")")
                .font(.title)
                .padding()
            
            Button(action: {
                cartVM.checkout()
            }) {
                Text("Checkout")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationTitle("Your Cart")
    }
}

// Orders View
struct OrdersView: View {
    @ObservedObject var cartVM: CartViewModel
    
    var body: some View {
        List {
            ForEach(cartVM.orders.indices, id: \ .self) { orderIndex in
                Section(header: Text("Order #\(orderIndex + 1)")) {
                    ForEach(cartVM.orders[orderIndex]) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .navigationTitle("My Orders")
    }
}


// Preview
#Preview  {
    ContentView()
}

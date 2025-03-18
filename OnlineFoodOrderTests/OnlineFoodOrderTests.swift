//
//  OnlineFoodOrderTests.swift
//  OnlineFoodOrderTests
//
//  Created by Mohar on 17/03/25.
//

import XCTest
@testable import OnlineFoodOrder

// Unit Tests
class CartViewModelTests: XCTestCase {
    func testAddingToCart() {
        let cartVM = CartViewModel()
        let item = FoodItem(name: "Burger", price: 5.99, image: "burger")
        cartVM.addToCart(item)
        XCTAssertEqual(cartVM.cartItems.count, 1)
    }
    
    func testRemovingFromCart() {
        let cartVM = CartViewModel()
        let item = FoodItem(name: "Burger", price: 5.99, image: "burger")
        cartVM.addToCart(item)
        cartVM.removeFromCart(at: 0)
        XCTAssertEqual(cartVM.cartItems.count, 0)
    }
    
    func testCheckout() {
        let cartVM = CartViewModel()
        let item = FoodItem(name: "Pizza", price: 7.99, image: "pizza")
        cartVM.addToCart(item)
        cartVM.checkout()
        XCTAssertEqual(cartVM.orders.count, 1)
        XCTAssertEqual(cartVM.cartItems.count, 0)
    }
}

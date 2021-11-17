//
//  Order.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

class Order: ObservableObject {
    @Published var items = [OrderDetail]()

    var total: Int {
        if items.count > 0 {
          return items.reduce(0) { $0 + ($1.menuItem.price * $1.quantity) }
        } else {
            return 0
        }
    }

  func add(item: MenuItem, count: Int) {
    if let item = items.first(where: { $0.menuItem == item }) {
      item.quantity += count
    } else {
      items.append(OrderDetail(menuItem: item, quantity: count))
    }
    }

//    func remove(item: MenuItem) {
//        if let index = items.firstIndex(of: item) {
//            items.remove(at: index)
//        }
//    }
}

class OrderDetail: Identifiable {
  var id = UUID()
  var menuItem: MenuItem
  var quantity: Int
  var subtotal: Int {
    menuItem.price * quantity
  }

  init(menuItem: MenuItem, quantity: Int) {
    self.menuItem = menuItem
    self.quantity = quantity
  }
}

//
//  CheckoutView.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentType = "Cash"
    @State private var addPromoCode = false
    @State private var promoCode = ""
    @State private var tipAmount = 0
    @State private var showingPaymentAlert = false

    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    let tipAmounts = [10, 15, 20, 25, 0]

    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)

        return formatter.string(from: NSNumber(value: total + tipValue)) ?? "$0"
    }

    var body: some View {
        Form {
            Section {
                Picker("Payment type", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }

                Toggle("Add Promo code", isOn: $addPromoCode.animation())

                if addPromoCode {
                    TextField("Enter Promo code", text: $promoCode)
                }
            }

          Section(header: Text("Items")) {
            ForEach(order.items) { item in
              HStack {
                if item.quantity > 1 {
                  Text("\(item.menuItem.name) X\(item.quantity)")
                } else {
                  Text(item.menuItem.name)
                }
                Spacer()
                Text("$\(item.subtotal)")
              }
            }
          }

            Section(header:
                Text("TOTAL: \(totalPrice)")
                        .font(.largeTitle) 
            ) {
                Button("Send order") {
                    showingPaymentAlert.toggle()
                }
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order confirmed"), message: Text("Your total was \(totalPrice)"), dismissButton: .default(Text("OK")))
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(Order())
    }
}

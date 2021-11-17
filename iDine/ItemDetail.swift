//
//  ItemDetail.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct ItemDetail: View {
  @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var order: Order
    let item: MenuItem

  @State private var quantity: Int = 1
  @State private var showAlert = false

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()

                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }

            Text(item.description)
              .padding()

          Stepper("Quantity: \(quantity)") {
            quantity += 1
          } onDecrement: {
            if quantity > 1 {
              quantity -= 1
            }
          }.padding()

            Button("Order This") {
              order.add(item: item, count: quantity)
              showAlert = true
              self.presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .alert(isPresented: $showAlert, content: {
              Alert(title: Text("\(quantity) \(item.name) added"))
            })
            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
          ItemDetail(item: MenuItem.example)
                .environmentObject(Order())
        }
    }
}

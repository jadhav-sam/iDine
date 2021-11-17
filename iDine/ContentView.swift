//
//  ContentView.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct ContentView: View {
    @State var menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @State var speechRecognizer = SpeechRecognizer()
    @State var search: KeywordSearch?

    var body: some View {
        NavigationView {
            List {
                ForEach(menu) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.items) { item in
                          NavigationLink(destination: ItemDetail(item: item)) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Menu")
            .navigationBarItems(trailing: Button {
              onDidMicTap()
              } label: {
                Image(systemName: "mic")
              }
            )
            .listStyle(GroupedListStyle())
        }
    }

   func onDidMicTap() {
      speechRecognizer.listen { (keywords) in
        search = KeywordSearch(menuSections: menu)
        menu = (search?.find(keywords: keywords))!
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

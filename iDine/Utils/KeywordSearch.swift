//
//  KeywordSearch.swift
//  iDine
//
//  Created by Samruddhi Jadhav on 17/11/21.
//

import Foundation

class KeywordSearch {
  private var menuSections: [MenuSection]
  
  init(menuSections: [MenuSection]) {
    self.menuSections = menuSections
  }
  
  func find(keywords: String) -> [MenuSection] {
    var filteredMenu = [MenuSection]()
    let keywords = keywords.split(separator: " ")
    for keyword in keywords {
      for menuSection in menuSections {
        var menuItems = [MenuItem]()
        for menuItem in menuSection.items {
          if menuItem.description.contains(keyword) || menuItem.name.contains(keyword) {
            menuItems.append(menuItem)
            filteredMenu.append(MenuSection(id: menuSection.id, name: menuSection.name, items: menuItems))
          }
        }
      }
    }
    return filteredMenu
  }
}

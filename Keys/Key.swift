//
//  Key.swift
//  Keys
//
//  Created by Parth Antala on 2024-01-27.
//

import Foundation
import AppIntents

struct Key: AppEntity {
    
    var id = UUID()
    var key: LocalizedStringResource
    var value: String
    
    init(key: LocalizedStringResource, value: String) {
        self.key = key
        self.value = value
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Key"
      var displayRepresentation: DisplayRepresentation {
          DisplayRepresentation(title: key)
      }

    static var defaultQuery = keyQuery()
    
    
}


struct keyQuery: EntityQuery {
    
    
  func entities(for identifiers: [UUID]) async throws -> [Key] {
      return  ViewModel.shared.data.filter { identifiers.contains($0.id) }
    
  }
    
    func suggestedEntities() async throws -> [Key] {
        return ViewModel.shared.data
        }
}


class ViewModel: ObservableObject {
    static let shared = ViewModel() // Singleton instance
    
    @Published var data: [Key] = []
   
    init() {
        // Initialize your data or perform any setup here
        let key1 = Key(key: "Banana", value: "Yellow")
        let key2 = Key(key: "Grapes", value: "Purple")
        data = [key1,key2]

    }
    
    func fetchData() {
        // Fetch data from somewhere and update the data property
    }
}

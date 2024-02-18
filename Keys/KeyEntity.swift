//
//  Key.swift
//  Keys
//
//  Created by Parth Antala on 2024-01-27.
//

import Foundation
import AppIntents

struct KeyEntity: AppEntity {
    
    let id: UUID
  //  var key: LocalizedStringResource
    let key: String
    let value: String
    
//    init(key: LocalizedStringResource, value: String) {
//        self.key = key
//        self.value = value
//    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "KeyEntity"
      var displayRepresentation: DisplayRepresentation {
          DisplayRepresentation(title: LocalizedStringResource("%@", defaultValue: String.LocalizationValue(key)))
      }

//    var displayRepresentation: DisplayRepresentation {
//            DisplayRepresentation(title: LocalizedStringResource("%@", defaultValue: String.LocalizationValue(key)))
//        }
//    
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Key"
    
    static var defaultQuery = keyQuery()
    
    
}


struct keyQuery: EntityQuery {
    
    
    func entities(for identifiers: [UUID]) async throws -> [KeyEntity] {
        return  identifiers.compactMap {KeyManager.key(for: $0) }
        
    }
    
    func suggestedEntities() async throws -> [KeyEntity] {
        //        return ViewModel.shared.data
        return KeyManager.shared
    }
}


class KeyManager: ObservableObject {
    static var shared: [KeyEntity] {
        return [
            KeyEntity(id: UUID(), key: "banana", value: "Yellow"),
            KeyEntity(id: UUID(), key: "grape", value: "Purple"),
            KeyEntity(id: UUID(), key: "apple", value: "red"),
            KeyEntity(id: UUID(), key: "pineapple", value: "green"),
            KeyEntity(id: UUID(), key: "github", value: "green")
        ]
    }
    
    let keys: [String] = shared.map { $0.key }
    
    static func key(for id: UUID) -> KeyEntity? {
        return shared.first { $0.id == id }
    }
}
    
class KeyModel {
    @Published
    var keys: [KeyEntity] = []
  

    init() {
        appShortcutProvider.updateAppShortcutParameters()
        
    }

    // ...

}


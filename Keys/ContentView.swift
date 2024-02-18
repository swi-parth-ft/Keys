//
//  ContentView.swift
//  Keys
//
//  Created by Parth Antala on 2024-01-20.
//
import CoreSpotlight
import SwiftUI
import AppIntents
import MobileCoreServices




//extension KeyType: _IntentValue {
//    
//    
//    public static func _fromInputValue(_ value: Any) -> KeyType? {
//            guard let stringValue = value as? String else {
//                return nil
//            }
//            return KeyType(rawValue: stringValue)
//        }
//
//        public func _toInputValue() -> Any {
//            rawValue
//        }
//}


struct CopyValue: AppIntent {
    
    static var title: LocalizedStringResource = "Copy value"
//    @EnvironmentObject var viewModel: ViewModel
    @Parameter(title: "keyType"/*, optionsProvider: KeyNamesOptionsProvider()*/)
        var keyType: KeyEntity?
    
    
   
//    private struct KeyNamesOptionsProvider: DynamicOptionsProvider {
//        func results() async throws -> [KeyEntity] {
//              // ["banana", "grapes","apple"]
//            print(KeyManager.shared.items)
//            return KeyManager.shared
//            
//            }
//        }
    
    static var openAppWhenRun = false
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        print(keyType ?? "none")
        guard let keyType = keyType else {
            return .result(
                        dialog: "Okay, starting a meditation session."
                    )
        }
        
        let key = KeyManager.shared.map {$0.value}
        return .result(dialog: "key of copied")
      
    }
    
}

struct appShortcutProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
    intent: CopyValue(),
    phrases: ["Copy value ",
              "boiled eggs and potatoes",
              "Show \(\CopyValue.$keyType) in \(.applicationName)",
              "Show keys in \(.applicationName)",
              "Search in \(.applicationName) for \(\CopyValue.$keyType)",
              "Copy \(.applicationName) for \(\CopyValue.$keyType)"
             ],
    //shortTitle: "\(\.$key)",
    systemImageName: "doc.on.doc"
    
    )
    }
}

struct ContentView: View {
    
    let appData = ["apple", "banana", "orange", "grape", "strawberry", "kiwi", "watermelon", "pineapple", "mango", "pear"]
   // @StateObject var viewModel = KeyManager.shared
    @State var result = ""
    @State private var selection: Int?
    
    
    
    var body: some View {
        VStack {
            Text("Hello!")
            
            List {
                Section {
                    ForEach(KeyManager.shared) { value in
                        
                        Text("\(value.key)")
                    }
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
            
            
            Button {
                KeyModel()
            } label: {
                Text("Index a page").font(.title)
            }
            
            Button {
                deleteData()
            } label: {
                Text("Delete Index").font(.title2)
            }
            
            Text(result).multilineTextAlignment(.center)
        }
        .padding()
    }
    
    
    
    func IndexData() {
        var searchableItems = [CSSearchableItem]()
        
        appData.forEach {item in
            let attribute = CSSearchableItemAttributeSet(contentType: .text)
            attribute.actionIdentifiers = ["copyValue"]
            attribute.title = item
            attribute.displayName = item
            attribute.contentDescription = item
            attribute.keywords = [item]
            attribute.phoneNumbers = ["6478060801"]
            attribute.supportsPhoneCall = false
            
        
            
            
            let sItem = CSSearchableItem(
                uniqueIdentifier: item, domainIdentifier: "com.test", attributeSet: attribute)
            
            
            searchableItems.append(sItem)
            print(item.description)
            print(item)
        }
        
        print(searchableItems)
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
            if let error {
                result = "Failed to index: \(error.localizedDescription)"
            } else {
                result = "Successefully indexed to spotlight. Try searching 'a page title'"
            }
        }
    }
    
    func deleteData() {
        CSSearchableIndex.default()
            .deleteSearchableItems(withDomainIdentifiers: ["com.test"])
    }
    
    func handleSpotlight(userActivity: NSUserActivity) {
        guard let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
            return
        }
        
        if let actionIdentifier = userActivity.userInfo?[CSActionIdentifier] as? String {
            if actionIdentifier == "copyValue" {
                print("Copied \(uniqueIdentifier)")
            }
        }
        
        userActivity.isEligibleForHandoff = true
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForPrediction = true
        userActivity.becomeCurrent()
    }
    
    func copyValue(item: String) {
        let clipboard = UIPasteboard.general
        clipboard.setValue(item, forPasteboardType: UTType.plainText.identifier)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "yourapp" && url.host == "copyAction" {
            // Implement code to copy the search result here
            return true
        }
        return false
    }

    
    
}





enum IntentHandlerError: Error {
    case invalidKey
}





#Preview {
    ContentView()
}

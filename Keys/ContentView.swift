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




struct CopyValue: AppIntent {
    static var title: LocalizedStringResource = "Copy value"
//    @EnvironmentObject var viewModel: ViewModel
    @Parameter(title: "Key")
    var key: Key?
    static var openAppWhenRun = false
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        
        
      //  let viewModel = ViewModel.shared // Access the shared instance directly
               
//               guard let key = key else {
//                   throw IntentHandlerError.invalidKey
//               }
        
        let valueToCopy: Key
           if let key = key {
               valueToCopy = key
           } else {
               
               valueToCopy = try await $key.requestDisambiguation(
                among: ViewModel.shared.data,
                dialog: "runnnning")
           }
        let contentView = ContentView()
        contentView.copyValue(item: valueToCopy.value)
       
        return .result(value: "copied value of \(valueToCopy.key)")
    }
    
}

struct appShortcutProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
    intent: CopyValue(),
    phrases: ["Copy value ",
              "boiled eggs and potatoes",
              "Show \(\.$key) in \(.applicationName)",
              "Show keys in \(.applicationName)"
             ]
    )
    }
}

struct ContentView: View {
    
    let appData = ["apple", "banana", "orange", "grape", "strawberry", "kiwi", "watermelon", "pineapple", "mango", "pear"]
    @StateObject var viewModel = ViewModel.shared
    @State var result = ""
    @State private var selection: Int?
    
    
    
    var body: some View {
        VStack {
            Text("Hello!")
            
            List {
                Section {
                    ForEach(ViewModel.shared.data) { value in
                        
                        Text("\(value.key)")
                    }
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
            
            
            Button {
                IndexData()
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
        .environmentObject(ViewModel.shared)
}

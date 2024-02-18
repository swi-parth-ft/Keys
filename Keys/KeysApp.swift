//
//  KeysApp.swift
//  Keys
//
//  Created by Parth Antala on 2024-01-20.
//

import SwiftUI
import CoreSpotlight




@main
struct KeysApp: App {
    
    let viewModel = KeyManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
           
        }
    }
    func handleSpotlight(_ userActivity: NSUserActivity) {
        print("Found \(userActivity.userInfo?.debugDescription ?? "nothing")")
    }
    
}

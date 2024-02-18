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
    
    let viewModel = ViewModel.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
           
        }
    }
    func handleSpotlight(_ userActivity: NSUserActivity) {
        print("Found \(userActivity.userInfo?.debugDescription ?? "nothing")")
    }
    
}

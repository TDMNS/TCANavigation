//
//  TCANavigationApp.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCANavigationApp: App {
    static let store = Store(initialState: ContactsFeature.State(), reducer: {
        ContactsFeature()
            ._printChanges()
    })
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: TCANavigationApp.store)
        }
    }
}

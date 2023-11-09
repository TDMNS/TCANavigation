//
//  ContactDetailView.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 09.11.2023.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    NavigationStack {
        ContactDetailView(
            store: Store(initialState: ContactDetailFeature.State(contact: Contact(id: UUID(), name: "Кенни")), reducer: {
                ContactDetailFeature()
            })
        )
    }
}

struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
            }
            .navigationBarTitle(viewStore.contact.name)
        }
    }
}

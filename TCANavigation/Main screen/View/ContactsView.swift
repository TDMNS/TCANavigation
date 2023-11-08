//
//  ContactsView.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(), name: "Кирилл"),
                    Contact(id: UUID(), name: "Марк"),
                    Contact(id: UUID(), name: "Арсений")
                ]), reducer: {
                    ContactsFeature()
                }
        )
    )
}

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        HStack {
                            Text(contact.name)
                            
                            Spacer()
                            
                            Button {
                                viewStore.send(.deleteButtonTapped(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(
            store: store.scope(state: \.$destination, action: { .destination($0) }),
            state: /ContactsFeature.Destination.State.addContact,
            action: ContactsFeature.Destination.Action.addContact
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert(
            store: store.scope(state: \.$destination, action: { .destination($0) }),
            state: /ContactsFeature.Destination.State.alert,
            action: ContactsFeature.Destination.Action.alert
        )

    }
}

//
//  AddContactView.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    NavigationStack {
      AddContactView(
        store: Store(
          initialState: AddContactFeature.State(
            contact: Contact(
              id: UUID(),
              name: "Андрей"
            )
          )
        ) {
          AddContactFeature()
        }
      )
    }
}

struct AddContactView: View {
    let store: StoreOf<AddContactFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                TextField("Имя", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
                Button("Сохранить") {
                    viewStore.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Отмена") {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
}

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
                if viewStore.isTextFieldEditable {
                    TextField("Имя", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
                    Button("Сохранить") {
                        viewStore.send(.saveButtonTapped)
                    }
                } else {
                    Text("Вы можете отредактировать имя контакта нажав на кнопку \"Редактировать\"")
                    Button("Редактировать") {
                        viewStore.send(.editButtonTapped)
                    }
                }
            }
            .navigationBarTitle(viewStore.contact.name)
        }
    }
}

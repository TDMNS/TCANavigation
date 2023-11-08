//
//  ContactsFeature.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture
import Foundation

struct ContactsFeature: Reducer {
    struct State: Equatable {
        @PresentationState var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        /// Слишком громоздко создавать действие делегата только для того, чтобы сообщить об скрытии представления родителю, поэтому в библиотеке есть специальный инструмент для этого.
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State.init(contact: Contact(id: UUID(), name: ""))
                return .none
            /// Удаляем логику с отменой представления, и ее занилением. Об этом позаботится библиотека :)
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
    }
}

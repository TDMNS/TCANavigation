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
        @PresentationState var alert: AlertState<Action.Alert>?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
        case alert(PresentationAction<Alert>)
        case deleteButtonTapped(id: Contact.ID)
        
        enum Alert: Equatable {
            /// Единственный выбор в оповещении — отменить или подтвердить удаление, но нам не нужно моделировать действие отмены. Это будет обработано автоматически за нас.
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State.init(contact: Contact(id: UUID(), name: ""))
                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            case let .alert(.presented(.confirmDeletion(id: id))):
                state.contacts.remove(id: id)
                return .none
            case .alert:
                return .none
            case let .deleteButtonTapped(id: id):
                state.alert = AlertState {
                    TextState("Are you shure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("Delete")
                    }
                }
                return .none
            }
        }
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}

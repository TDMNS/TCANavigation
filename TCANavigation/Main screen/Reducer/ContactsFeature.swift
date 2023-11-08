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
        @PresentationState var destination: Destination.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)
        
        enum Alert: Equatable {
            /// Единственный выбор в оповещении — отменить или подтвердить удаление, но нам не нужно моделировать действие отмены. Это будет обработано автоматически за нас.
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        /// Теперь наша модель определена более кратко, и во время компиляции у нас есть гарантии того, что одновременно может быть активен только один пункт назначения (либо алерт, либо sheet).
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
                )
                return .none
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you shure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension ContactsFeature {
    /// Роутер отвечающий за навигацию
    struct Destination: Reducer {
        enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        
        enum Action: Equatable {
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        
        var body: some ReducerOf<Self> {
            /// Scope reducer нужен чтобы сосредоточиться на области действия reducer-а.
            Scope(state: /State.addContact, action: /Action.addContact) {
                AddContactFeature()
            }
        }
    }
}

//
//  AddContactFeature.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture

/// Для начала глянь в ContactFeature
struct AddContactFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        /// Это перечисление будет описывать все действия, которые родитель может прослушивать и интерпретировать. Это позволяет дочерней фиче напрямую сообщать родительской фиче, что она хочет сделать.
        enum Delegate: Equatable {
            case cancel
            case saveContact(Contact)
        }
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .send(.delegate(.cancel))
        case .delegate:
            return .none
        case .saveButtonTapped:
            return .send(.delegate(.saveContact(state.contact)))
        case let .setName(name):
            state.contact.name = name
            return .none
        }
    }
}

//
//  AddContactFeature.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture

struct AddContactFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)

        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { _ in await dismiss() }
        case .delegate:
            return .none
        case .saveButtonTapped:
            return .run { [contact = state.contact] send in
                guard !contact.name.isEmpty else { return }
                await send(.delegate(.saveContact(contact)))
                await dismiss()
            }
        case let .setName(name):
            state.contact.name = name
            return .none
        }
    }
}

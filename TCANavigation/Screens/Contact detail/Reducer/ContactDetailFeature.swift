//
//  ContactDetailFeature.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 09.11.2023.
//

import Foundation
import ComposableArchitecture

struct ContactDetailFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
        var isTextFieldEditable = false
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        case saveButtonTapped
        case editButtonTapped
        case setName(String)

        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .delegate:
            return .none
        case .saveButtonTapped:
            return .run { [contact = state.contact] send in
                await send(.delegate(.saveContact(contact)))
                await dismiss()
            }
        case let .setName(name):
            state.contact.name = name
            return .none
        case .editButtonTapped:
            state.isTextFieldEditable = true
            return .none
        }
    }
}

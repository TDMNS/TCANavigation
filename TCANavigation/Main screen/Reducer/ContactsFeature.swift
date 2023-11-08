//
//  ContactsFeature.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture
import Foundation

/// Это не идеальный вариант, поскольку может привести к тому, что родительский объект будет делать предположения о том, какую логику он должен выполнять, когда что-то происходит в дочернем объекте. Лучше использовать так называемые «delegate actions» для дочерней фичи, чтобы напрямую сообщать родительской, что она хочет сделать.
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
        /// обновим редуктор для прослушивания действий делегата и определения того, когда пора отклонить или сохранить контакт.
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State.init(contact: Contact(id: UUID(), name: ""))
                return .none
            case .addContact(.presented(.delegate(.cancel))):
                state.addContact = nil
                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                state.addContact = nil
                return .none
            case .addContact:
                return .none
            }
        }
        /// Приложение должно работать точно так же, как и до рефакторинга «delegate actions», но теперь дочерняя фича может точно описывать то, что она хочет от родительской, а не наоборот. Родительская больше не выстраивает предположение о том или ином действии.
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
    }
}

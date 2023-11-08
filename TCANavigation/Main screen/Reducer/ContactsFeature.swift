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
        /// Значение nil означает, что функция «Добавить контакты» не представлена, а значение, отличное от nil, означает, что она представлена.
        @PresentationState var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        case addButtonTapped
        /// Это позволяет родительскому элементу наблюдать за каждым действием, отправленным дочерней функцией.
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                /// При нажатии кнопки «+» в функции списка контактов мы теперь можем заполнить состояние addContact, чтобы указать, что эта функция должна быть представлена.
                state.addContact = AddContactFeature.State.init(contact: Contact(id: UUID(), name: ""))
                return .none
            case .addContact(.presented(.cancelButtonTapped)):
                state.addContact = nil
                return .none
            case .addContact(.presented(.saveButtonTapped)):
                guard let contact = state.addContact?.contact else { return .none }
                state.contacts.append(contact)
                state.addContact = nil
                return .none
            case .addContact:
                return .none
            }
        }
        /// Кстати, если вы не значете что такое KPE, то рекоммендую почитать документацию на эту тему: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/expressions/#Key-Path-Expression
        /// В данном случае \.addContact указывает на свойство (или ключ) в состоянии приложения.
        /// А /Action.addContact используется для создания пути на action
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
        /// 32 - 34 строка создает новый reducer, который запускает дочерний, когда дочернее действие поступает в систему, и запускает родительский reducer для всех действий. Он также автоматически обрабатывает отмену эффекта при закрытии дочерней функции и многое другое. Подробнее: https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:destination:fileid:line:)/
    }
}

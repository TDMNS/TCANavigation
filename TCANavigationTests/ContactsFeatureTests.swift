//
//  ContactsFeatureTests.swift
//  TCANavigationTests
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

@MainActor
final class ContactsFeatureTests: XCTestCase {
    func testAddFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(contact: Contact(id: UUID(0), name: ""))
            )
        }
        
        await store.send(.destination(.presented(.addContact(.setName("Эвелина"))))) {
            $0.$destination[case: /ContactsFeature.Destination.State.addContact]?.contact.name = "Эвелина"
        }
        
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.receive(.destination(.presented(.addContact(.delegate(.saveContact(Contact(id: UUID(0), name: "Эвелина"))))))) {
            $0.contacts = [Contact(id: UUID(0), name: "Эвелина")]
        }
        await store.receive(.destination(.dismiss)) { $0.destination = nil }
    }
    
    /// Код выше выглядит немного сложным. Что если попробовать написать немножко в другом стиле? В более упрощенном (неисчерпывающем).
    /// Интересное примечание... почему-то разработчики TCA используют названия типа testAddFlow_NonExhaustive... Почему они используют underscore не понятно...
    /// Может у вас есть идеи?
    func testAddFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        /// Отключаем исчерпываемость. В таких хранилищах нет необходимости предоставлять trailing clouse (если вы этого сами не захотите).
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(.destination(.presented(.addContact(.setName("Эвелина")))))
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.skipReceivedActions() /// дожидаемся момент пока все действия не будут получены.
        store.assert {
            $0.contacts = [Contact(id: UUID(0), name: "Эвелина")]
            $0.destination = nil
        }
    }
}

/// Какой вариант читается лучше, и вам больше нравится?

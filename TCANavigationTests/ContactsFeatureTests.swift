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
            /// Переопределение зависимости в хранилище тестов. Это нужно для того, чтобы оно использовало управляемый генератор UUID. В частности, мы будем использовать «инкрементирующий» генератор, который генерирует последовательные возрастающие идентификаторы, начиная с 0.
            $0.uuid = .incrementing
        }

        
        /// В настоящее время ContactsFeature использует неконтролируемую зависимость, что очень затрудняет тестирование этой функции. При представлении этой функции он создает случайный UUID, и мы не можем предсказать этот идентификатор, чтобы пройти тест.
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                /// Тут мы используем инициализатор UUID, который позволяет предоставить целое число, предоставляется нашей библиотекой быстрых зависимостей, от которой зависит составная архитектура.
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
}

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
    
    func testAddFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(.destination(.presented(.addContact(.setName("Эвелина")))))
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.skipReceivedActions()
        store.assert {
            $0.contacts = [Contact(id: UUID(0), name: "Эвелина")]
            $0.destination = nil
        }
    }
    
    func testDeleteContact() async {
        let store = TestStore(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(0), name: "Эвелина"),
                    Contact(id: UUID(1), name: "Аркадий")
                ]
            )) {
            ContactsFeature()
        }
        /// Заметили? Повторение функционала
        await store.send(.deleteButtonTapped(id: UUID(1))) {
            $0.destination = .alert(
                AlertState {
                    TextState("Are you shure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: UUID(1))) {
                        TextState("Delete")
                    }
                }
            )
        }
    }
}

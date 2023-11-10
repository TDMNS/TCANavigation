//
//  SharedContacts.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 10.11.2023.
//

import Foundation

class SharedContacts {
    static let instance = SharedContacts()
    private init() { }
    var contacts: [Contact] {
        get {
            guard let data = try? Data(contentsOf: .contacts) else { return [] }
            return (try? JSONDecoder().decode([Contact].self, from: data)) ?? []
        }
        set {
            try? JSONEncoder().encode(newValue).write(to: .contacts)
        }
    }
}

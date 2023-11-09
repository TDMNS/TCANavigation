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
        let contact: Contact
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

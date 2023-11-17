//
//  UrlSavingData.swift
//  TCANavigation
//
//  Created by Oleg Kolbasa on 10.11.2023.
//

import Foundation

extension URL {
    static var contacts: URL {
        let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier ?? "TDMNS"
        let subDirectory = applicationSupport.appendingPathComponent(bundleID, isDirectory: true)
        try? FileManager.default.createDirectory(at: subDirectory, withIntermediateDirectories: true, attributes: nil)
        return subDirectory.appendingPathComponent("contacts.json")
    }
}

//
//  anchorApp.swift
//  anchor
//
//  Created by Alex Yu on 2025/10/30.
//

import SwiftData
import SwiftUI

@main
struct anchorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CheckInItem.self)
    }
}

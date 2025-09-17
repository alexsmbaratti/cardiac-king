//
//  Poker_Face_visionOSApp.swift
//  Poker Face visionOS
//
//  Created by Alex Baratti on 3/2/25.
//

import SwiftUI

@main
struct Poker_Face_visionOSApp: App {
    @State var openWindows: Set<String> = []
    
    var body: some Scene {
        WindowGroup {
            ContentView(openWindows: $openWindows)
                .frame(minWidth: 850, minHeight: 850)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "quick-reference") {
            QuickReferenceView()
                .frame(minWidth: 600, maxWidth: 600, minHeight: 600)
                .onDisappear(perform: {
                    openWindows.remove("quick-reference")
                })
        }
        .windowResizability(.contentSize)
    }
}

//
//  Poker_FaceApp.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/11/22.
//

import SwiftUI

@main
struct Poker_FaceApp: App {
    @State var openWindows: Set<String> = []
    
    var body: some Scene {
        WindowGroup {
            ContentView(openWindows: $openWindows)
        }

#if !os(iOS) // TODO: Evaluate if this behavior works well on iPadOS 26 windowing
        WindowGroup(id: "quick-reference") {
            QuickReferenceView(isShowing: .constant(true))
                .frame(minWidth: 600, maxWidth: 600, minHeight: 600)
                .onDisappear(perform: {
                    openWindows.remove("quick-reference")
                })
        }
        .windowResizability(.contentSize)
#endif
    }
}

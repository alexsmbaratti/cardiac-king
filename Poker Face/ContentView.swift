//
//  ContentView.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/11/22.
//

import SwiftUI

struct ContentView: View {
    @State var showRandomGame = false
    @State var showQuickReference = false
    @State var selectedGame: Game? = nil
    
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @State private var showDisclaimer = false
    
    @Binding var openWindows: Set<String>
    
    @Environment(\.horizontalSizeClass) var sizeClass
#if !os(iOS)
    @Environment(\.openWindow) private var openWindow
#endif
    
    var body: some View {
        NavigationSplitView(sidebar: {
            VStack {
                List(selection: $selectedGame) {
                    ForEach(games) { game in
                        NavigationLink(value: game, label: {
                            HStack {
                                Text(game.name)
                                Spacer()
                            }
                        })
                    }
                }
                .listStyle(.inset)
            }
            .onAppear {
                if !hasSeenDisclaimer {
                    showDisclaimer = true
                }
            }
            .navigationTitle("Cardiac King")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        showRandomGame = true
                    }, label: {
                        Label("Random Game", systemImage: "die.face.6")
                    })
                    .tint(.accentColor)
#if !os(iOS)
                    .disabled(openWindows.contains("quick-reference"))
#endif
                })
                if UIDevice.current.userInterfaceIdiom == .phone {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: handleQuickReferenceTap, label: {
                            Label("Quick Reference", systemImage: "rectangle.portrait.on.rectangle.portrait.angled")
                        })
                        .tint(.accentColor)
                        .accessibilityIdentifier("universalQuickReferenceButton")
#if !os(iOS)
                        .disabled(openWindows.contains("quick-reference"))
#endif
                    })
                }
            }
        }, detail: {
            if selectedGame != nil {
                GameDetailView(game: selectedGame!, showQuickReference: $showQuickReference, openWindows: $openWindows)
            } else {
                NoGameSelectedView(showQuickReference: $showQuickReference)
            }
        })
#if os(iOS)
        .sheet(isPresented: $showQuickReference, content: {
            QuickReferenceView()
        })
#endif
        .sheet(isPresented: $showDisclaimer) {
            DisclaimerView(isPresented: $showDisclaimer)
        }
        .sheet(isPresented: $showRandomGame, content: {
            RandomGameView(parentSelectedGame: $selectedGame)
        })
    }
    
    private func handleQuickReferenceTap() {
#if !os(iOS)
        if !openWindows.contains("quick-reference") {
            openWindow(id: "quick-reference")
            openWindows.insert("quick-reference")
        }
#else
        showQuickReference = true
#endif
    }
}

struct DisclaimerView: View {
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "info.bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Disclaimer")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("This app is purely for educational purposes. This app does not facilitate gambling or real-money transactions. All content is purely for learning and practicing poker strategies in a risk-free environment. Please play responsibly.")
                .multilineTextAlignment(.leading)
                .padding()
            
            Spacer()
            Button("Acknowledge") {
                hasSeenDisclaimer = true
                isPresented = false
            }
            .font(.title3)
            .bold()
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .interactiveDismissDisabled()
    }
}

struct AccentGradientBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
#if !os(visionOS)
            .background(
                Group {
                    if #available(iOS 26.0, *) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.accentColor.opacity(colorScheme == .light ? 1 : 0.5),
                                Color.clear
                            ]),
                            startPoint: .top,
                            endPoint: .center
                        )
                        .ignoresSafeArea(edges: [.top, .leading, .trailing])
                    }
                }
            )
#endif
    }
}



extension View {
    func accentGradientBackground() -> some View {
        self.modifier(AccentGradientBackground())
    }
}


#Preview {
    ContentView(openWindows: .constant([]))
}

#Preview {
    DisclaimerView(isPresented: .constant(true))
}

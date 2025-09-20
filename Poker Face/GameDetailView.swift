//
//  GameView.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/14/22.
//

import SwiftUI

struct GameDetailView: View {
    var game: Game
    
    @Binding var showQuickReference: Bool
    @Binding var openWindows: Set<String>
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ScrollView {
            Group {
                if let format = game.format {
                    HStack {
                        Text("\(format.name) Format")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                            .italic()
                        Spacer()
                    }
                    Divider()
                }
                if game.hasWilds() {
                    Heading(text: "Wild Cards")
                    CardBunchReferenceView(cardBunches: game.getAllWildCards())
                }
                if game.hasRankValues() {
                    Heading(text: "Special Rank Values")
                    CardBunchReferenceView(cardBunches: game.rankValues!)
                }
                if game.hasWinningHands() {
                    Heading(text: "Winning Hands")
                    CardBunchReferenceView(cardBunches: game.winningHands)
                }
                Heading(text: "How to Play")
                HowToView(
                    steps: game.steps,
                    deferredFormat: game.deferToFormat ?? false ? game.format : nil,
                    showQuickReference: $showQuickReference,
                    openWindows: $openWindows
                )
                if game.hasVariants() {
                    Heading(text: "Variants")
                    VariantsView(variants: game.variants)
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .navigationTitle(game.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: handleQuickReferenceTap, label: {
                    Label("Quick Reference", systemImage: "rectangle.portrait.on.rectangle.portrait.angled")
                })
                .accessibilityIdentifier("universalQuickReferenceButton")
#if !os(iOS)
                .disabled(openWindows.contains("quick-reference"))
#endif
            })
        }
        .accentGradientBackground()
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

struct                 NoGameSelectedView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        VStack {
            Spacer()
            CardView(card: Card(rank: .king, suit: .heart, side: .face_up))
                .padding(.all)
            Text("Select a Game")
                .font(.title)
                .bold()
            if sizeClass != .compact {
                Text("Tap the icon in the top left corner to reveal the game drawer")
                    .font(.title2)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accentGradientBackground()
    }
}


struct HowToView: View {
    var steps: [Instruction]
    var deferredFormat: GameFormat?
    
    @State var collapseDeferredSteps = true
    
    @Binding var showQuickReference: Bool
    @Binding var openWindows: Set<String>
    
    var body: some View {
        if !steps.isEmpty {
            if deferredFormat != nil && collapseDeferredSteps {
                HStack {
                    Spacer()
                    VStack {
                        Text("Play Standard \(deferredFormat!.name)")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Button(action: {
                            collapseDeferredSteps = false
                        }) {
                            Label("Show Steps", systemImage: "list.bullet")
                                .fontWeight(.semibold)
                                .font(.headline)
                                .padding()
#if !os(visionOS)
                                .foregroundColor(.white) // Needed to prevent green text on iOS
                                .background(.primary) // Needed to give button accent color on iOS
#else
                                .backgroundStyle(.primary)
#endif
                                .cornerRadius(20)
                        }
                        .accessibilityIdentifier("showDeferredStepsButton")
                    }
                    Spacer()
                }
                .padding(.all)
                .aspectRatio(contentMode: .fill)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .foregroundColor(Color(.systemFill))
                        .shadow(radius: 7)
                )
            } else {
                VStack {
                    ForEach(0..<steps.count, id: \.self) { index in
                        StepView(num: index + 1, step: steps[index], showQuickReference: $showQuickReference, openWindows: $openWindows)
                    }
                }
                .padding(.all)
                .aspectRatio(contentMode: .fill)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .foregroundColor(Color(.systemFill))
                        .shadow(radius: 7)
                )
            }
        } else {
            HStack {
                Spacer()
                Text("No Steps")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.all)
            .aspectRatio(contentMode: .fill)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .foregroundColor(Color(.systemFill))
                    .shadow(radius: 7)
            )
        }
    }
}

struct VariantsView: View {
    var variants: [Variant]
    
    var body: some View {
        if !variants.isEmpty {
            VStack {
                ForEach(variants, id: \.self) { variant in
                    VariantView(variant: variant)
                }
            }
            .padding(.all)
            .aspectRatio(contentMode: .fill)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .foregroundColor(Color(.systemFill))
                    .shadow(radius: 7)
            )
        } else {
            HStack {
                Spacer()
                Text("No Variants")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.all)
            .aspectRatio(contentMode: .fill)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .foregroundColor(Color(.systemFill))
                    .shadow(radius: 7)
            )
        }
    }
}

struct CardBunchReferenceView: View {
    var cardBunches: [CardBunch]
    
    var body: some View {
        VStack {
            ForEach(cardBunches, id: \.self) { cardBunch in
                CardBunchView(text: cardBunch.description, cards: cardBunch.cards)
            }
        }
        .padding(.all)
        .aspectRatio(contentMode: .fill)
        .background(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .foregroundColor(Color(.systemFill))
                .shadow(radius: 7)
        )
    }
}

struct VariantView: View {
    var variant: Variant
    
    var body: some View {
        VStack {
            HStack {
                Text(variant.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Text(variant.description)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

struct CardBunchView: View {
    var text: String
    var cards: [Card]
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Spacer()
                if !cards.isEmpty {
                    CardStackView(cards: cards)
                        .scaleEffect(0.7)
                }
            }
        }
        .frame(height: 80)
    }
}

private struct Heading: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct StepView: View {
    var num: Int
    var step: Instruction
    
    @Binding var showQuickReference: Bool
    @Binding var openWindows: Set<String>
    
    @Environment(\.colorScheme) var colorScheme
#if !os(iOS)
    @Environment(\.openWindow) private var openWindow
#endif
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(.quaternary)
                Text(String(num))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(height: 50)
            VStack {
                HStack {
                    Text(step.description)
                        .font(.title3)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                if step.subtext != nil {
                    HStack {
                        Text(step.subtext!)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }
            .padding(.leading)
            Spacer()
        }
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameDetailView(game: Game(name: "My Poker Game", icon: "sparkles", steps: [Instruction(description: "First", subtext: "Subtext"), Instruction(description: "Second"), Instruction(description: "Third", subtext: "Subtext")], wildRanks: [.seven, .nine], wildCards: [Card(rank: .queen, suit: .heart)], wildCustoms: ["Some Wild Cards"], winningHands: [CardBunch(description: "Adds to 5", cards: [Card(rank: .three, suit: .wild), Card(rank: .two, suit: .wild)])], rankValues: [CardBunch(description: "11", cards: [Card(rank: .ace, suit: .heart)])], variants: [Variant(name: "My Variant", description: "Instead of doing foo, jump five times, then bar")], format: .five_card_draw), showQuickReference: .constant(false), openWindows: .constant([]))
        }
    }
}

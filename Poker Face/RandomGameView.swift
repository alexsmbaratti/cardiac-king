//
//  RandomGameView.swift
//  Poker Face
//
//  Created by Alex Baratti on 9/17/25.
//

import SwiftUI

struct RandomGameView: View {
    @State private var selected: Game?
    @State private var isAnimating = false
    @State private var flipped = false
    
    @Binding var parentSelectedGame: Game?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                FlippableCard(
                    flipped: $flipped, front: Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray),
                    back: Group {
                        if let selected = selected {
                            switch selected.id {
                            case 11:
                                CardView(card: Card(rank: .ace, suit: .heart))
                                    .scaleEffect(2)
                                    .padding(.all, 3.0)
                            case 5:
                                CardView(card: Card(rank: .seven, suit: .club))
                                    .scaleEffect(2)
                                    .padding(.all, 3.0)
                            case 8:
                                CardView(card: Card(rank: .jack, suit: .diamond))
                                    .scaleEffect(2)
                                    .padding(.all, 3.0)
                            default:
                                Image(systemName: selected.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .id(selected.id)
                                    .foregroundStyle(.gray)
                            }
                        } else {
                            Image(systemName: "questionmark")
                        }
                    }
                )
                if let selected = selected {
                    Text(selected.name)
                        .font(.title)
                        .id(selected.id)
#if os(iOS)
                        .bold()
#endif
                }
                Spacer()
                if let selected = selected {
                    Button(action: {
                        parentSelectedGame = selected
                        dismiss()
                    }) {
                        Text("Play")
#if os(iOS)
                            .bold()
#endif
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.borderedProminent)
#if os(iOS)
                    .tint(.accentColor)
#endif
                }
                
                Button(action: pickRandom) {
                    Text("Pick Random Game")
#if os(iOS)
                        .bold()
#endif
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                }
                .buttonStyle(.bordered)
                .disabled(isAnimating)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                })
            }
            .navigationTitle("Game Picker")
            .navigationBarTitleDisplayMode(.inline)
        }
        .animation(.spring(), value: selected)
    }
    
    private func pickRandom() {
        guard !games.isEmpty else { return }
        
        isAnimating = true
        selected = nil
        
        if flipped {
            flipped = false
            Task {
                try await Task.sleep(nanoseconds: 600_000_000)
                updateSelection()
            }
        } else {
            updateSelection()
        }
    }

    private func updateSelection() {
        selected = games.randomElement()
        flipped = true
        
        Task {
            try await Task.sleep(nanoseconds: 600_000_000)
            isAnimating = false
    #if os(iOS)
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.success)
    #endif
        }
    }
}

#Preview {
    RandomGameView(parentSelectedGame: .constant(nil))
}

struct FlippableCard<Front: View, Back: View>: View {
    @Binding var flipped: Bool

    let front: Front
    let back: Back

    var body: some View {
        ZStack {
            front
                .opacity(flipped ? 0 : 1)
            back
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 140, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(radius: 5)
        )
        .rotation3DEffect(
            .degrees(flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.7
        )
        .animation(.easeInOut(duration: 0.6), value: flipped)
    }
}


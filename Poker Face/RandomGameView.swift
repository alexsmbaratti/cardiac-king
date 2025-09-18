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
    
    @Binding var parentSelectedGame: Game?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let selected = selected {
                    Image(systemName: selected.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .id(selected.id)
                    Text(selected.name)
                        .font(.title)
                        .bold()
                } else {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.secondary)
                }
                
                if !isAnimating, let selected = selected {
                    Button(action: {
                        parentSelectedGame = selected
                        dismiss()
                    }) {
                        Text("Play")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(isAnimating)
                }
                
                Button(action: pickRandom) {
                    Text("Pick Random")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isAnimating)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                })
            }
        }
        .padding()
        .animation(.spring(), value: selected)
    }
    
    private func pickRandom() {
        guard !games.isEmpty else { return }
        isAnimating = true
        
#if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .light)
        let finalImpact = UINotificationFeedbackGenerator()
#endif
        
        let rounds = 10
        let interval = 0.1
        
        for i in 0..<rounds {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * interval) {
                withAnimation {
                    selected = games.randomElement()
                }
                
#if os(iOS)
                if i < rounds - 1 {
                    impact.impactOccurred(intensity: 0.7)
                } else {
                    finalImpact.notificationOccurred(.success)
                }
#endif
                
                if i == rounds - 1 {
                    isAnimating = false
                }
            }
        }
    }
}

#Preview {
    RandomGameView(parentSelectedGame: .constant(nil))
}

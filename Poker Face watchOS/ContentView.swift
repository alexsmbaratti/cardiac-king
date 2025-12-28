//
//  ContentView.swift
//  Poker Face watchOS
//
//  Created by Alex Baratti on 3/2/25.
//

import SwiftUI
import SeizosUI

struct ContentView: View {
    var body: some View {
        HandsView()
            .gradientBackground(color: .accentColor)
    }
}

struct HandsView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Hand.allCases, id: \.rawValue) { hand in
                    VStack {
                        TinyCardStackView(cards: hand.exampleHand)
                        Text(hand.name)
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Divider()
                            .padding(.top, 22)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct TinyCardStackView: View {
    var cards: [Card]

    var body: some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                TinyCardView(card: cards[index])
                    .offset(x: CGFloat(25 * index))
            }
        }
        .offset(x: -50)
        .frame(width: CGFloat(cards.count) * 40, height: 125)
    }
}

struct TinyCardView: View {
    var card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(card.isFaceUp ? .white : .gray)
                .shadow(radius: 5)
            if card.isFaceUp {
                HStack {
                    label
                        .pinnedToTop()
                        .dynamicTypeSize(.medium)
                    Spacer()
                }
                .padding(.all, 3.0)
            }
        }
        .frame(width: 50, height: 70)
    }
    
    var label: some View {
        VStack {
            Text(card.rank.symbol)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Image(systemName: card.suit.symbol)
                .foregroundColor(card.suit.color)
        }
    }
}

#Preview {
    ContentView()
}

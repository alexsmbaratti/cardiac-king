//
//  QuickReferenceView.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/11/22.
//

import SwiftUI

// TODO: Abstract into sheet and window
struct QuickReferenceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(Hand.allCases, id: \.rawValue) { hand in
                    HandReferenceView(hand: hand)
                    Divider()
                }
            }
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                })
            }
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
#endif
            .padding(.horizontal)
            .navigationTitle("Quick Reference")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HandReferenceView: View {
    var hand: Hand
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text(hand.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text(hand.description)
                            .font(.callout)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .multilineTextAlignment(.leading)
                CardStackView(cards: hand.exampleHand)
            }
            Spacer()
        }
    }
}

struct CardStackView: View {
    var cards: [Card]
    
    var body: some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index])
                    .offset(x: CGFloat(25 * index))
            }
        }
        .offset(x: -50)
        .frame(width: CGFloat(cards.count) * 40, height: 125)
    }
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(card.isFaceUp ? .white : .gray)
                .shadow(radius: 5)
            if card.isFaceUp {
                FaceUpCardView(card: card)
            }
        }
        .frame(width: 70, height: 100)
    }
}

struct FaceUpCardView: View {
    var card: Card
    
    var body: some View {
        HStack {
            VStack {
                label
                Spacer()
            }
            .dynamicTypeSize(.medium)
            Spacer()
            VStack {
                label
                Spacer()
            }
            .rotationEffect(.degrees(180))
        }
        .padding(.all, 3.0)
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

struct QuickReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        QuickReferenceView()
    }
}

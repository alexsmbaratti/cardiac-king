//
//  Card.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/11/22.
//

import Foundation
import SwiftUI

class CardUtils {
    static func allOfSameSuit(cards: [Card]) -> Bool {
        return cards.dropFirst().allSatisfy({ $0.suit == cards.first?.suit })
    }
    
    static func allOfSameRank(cards: [Card]) -> Bool {
        return cards.dropFirst().allSatisfy({ $0.rank == cards.first?.rank })
    }
    
    static func containsRank(rank: Rank, cards: [Card]) -> Bool {
        return !cards.filter({ $0.rank == rank }).isEmpty
    }
    
    static func containsRanks(ranks: [Rank], cards: [Card]) -> Bool {
        return ranks.allSatisfy({ self.containsRank(rank: $0, cards: cards) })
    }
    
    static func isFullHand(cards: [Card]) -> Bool {
        return cards.count == 5
    }
    
    static func isSequenceHand(cards: [Card]) -> Bool {
        guard cards.count >= 2 else { return false }

        let values = cards.map { $0.rank.rawValue }.sorted()

        var isSequential = true
        for i in 1..<values.count {
            if values[i] != values[i - 1] + 1 {
                isSequential = false
                break
            }
        }
        if isSequential { return true }

        let aceLowValues = cards.map { $0.rank == .ace ? 1 : $0.rank.rawValue }.sorted()
        for i in 1..<aceLowValues.count {
            if aceLowValues[i] != aceLowValues[i - 1] + 1 {
                return false
            }
        }
        return true
    }
    
    static func allDistinctRanks(cards: [Card]) -> Bool {
        return false // TODO
    }
    
    static func isCyclic(cards: [Card]) -> Bool {
        return self.containsRanks(ranks: [.king, .ace, .two], cards: cards)
    }
    
    static func getHand(cards: [Card]) -> Hand {
        guard self.isFullHand(cards: cards) else { return .high_card }

        if self.allOfSameSuit(cards: cards) && self.containsRanks(ranks: [.ace, .king, .queen, .jack, .ten], cards: cards) {
            return .royal_flush
        }

        if self.allOfSameSuit(cards: cards) && self.isSequenceHand(cards: cards) {
            return .straight_flush
        }

        if let rankCounts = self.rankCounts(cards: cards) {
            if rankCounts.values.contains(4) {
                return .four_of_a_kind
            } else if rankCounts.values.contains(3) && rankCounts.values.contains(2) {
                return .full_house
            } else if rankCounts.values.contains(3) {
                return .three_of_a_kind
            } else if rankCounts.values.filter({ $0 == 2 }).count == 2 {
                return .two_pair
            } else if rankCounts.values.contains(2) {
                return .one_pair
            }
        }

        if self.allOfSameSuit(cards: cards) {
            return .flush
        }

        if self.isSequenceHand(cards: cards) {
            return .straight
        }

        return .high_card
    }
    
    private static func rankCounts(cards: [Card]) -> [Rank: Int]? {
        guard !cards.isEmpty else { return nil }
        var counts: [Rank: Int] = [:]
        for card in cards {
            counts[card.rank, default: 0] += 1
        }
        return counts
    }
}

struct Card: CustomStringConvertible, Hashable, Codable {
    var rank: Rank
    var suit: Suit
    var side: CardSide = .face_up
    
    var description: String {
        return "\(rank) of \(suit)"
    }
    
    var isFaceUp: Bool {
        return side == .face_up
    }
}

struct CardBunch: Codable, Hashable {
    var description: String
    var cards: [Card]
}

enum CardSide: Int, Codable {
    case face_down = 0
    case face_up = 1
}

enum Suit: Int, CustomStringConvertible, Codable {
    case club = 0
    case diamond = 1
    case heart = 2
    case spade = 3
    case wild = 4
    
    var symbol: String {
        switch self {
        case .club:
            return "suit.club.fill"
        case .diamond:
            return "suit.diamond.fill"
        case .heart:
            return "suit.heart.fill"
        case .spade:
            return "suit.spade.fill"
        case .wild:
            return "questionmark"
        }
    }
    
    var description: String {
        switch self {
        case .club:
            return "Clubs"
        case .diamond:
            return "Diamonds"
        case .heart:
            return "Hearts"
        case .spade:
            return "Spades"
        case .wild:
            return "Any Suit"
        }
    }
    
    var color: Color {
        switch self {
        case .club:
            return .black
        case .diamond:
            return .red
        case .heart:
            return .red
        case .spade:
            return .black
        case .wild:
            return .gray
        }
    }
}

enum Rank: Int, CaseIterable, CustomStringConvertible, Codable {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    
    var symbol: String {
        switch self {
        case .ace:
            return "A"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .ten:
            return "10"
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
        }
    }
    
    var higherRank: Rank {
        switch self {
        case .ace:
            return .two
        case .two:
            return .three
        case .three:
            return .four
        case .four:
            return .five
        case .five:
            return .six
        case .six:
            return .seven
        case .seven:
            return .eight
        case .eight:
            return .nine
        case .nine:
            return .ten
        case .ten:
            return .jack
        case .jack:
            return .queen
        case .queen:
            return .king
        case .king:
            return .ace
        }
    }
    
    var lowerRank: Rank {
        switch self {
        case .ace:
            return .king
        case .two:
            return .ace
        case .three:
            return .two
        case .four:
            return .three
        case .five:
            return .four
        case .six:
            return .five
        case .seven:
            return .six
        case .eight:
            return .seven
        case .nine:
            return .eight
        case .ten:
            return .nine
        case .jack:
            return .ten
        case .queen:
            return .jack
        case .king:
            return .queen
        }
    }
    
    var description: String {
        switch self {
        case .ace:
            return "Ace"
        case .two:
            return "Two"
        case .three:
            return "Three"
        case .four:
            return "Four"
        case .five:
            return "Five"
        case .six:
            return "Six"
        case .seven:
            return "Seven"
        case .eight:
            return "Eight"
        case .nine:
            return "Nine"
        case .ten:
            return "Ten"
        case .jack:
            return "Jack"
        case .queen:
            return "Queen"
        case .king:
            return "King"
        }
    }
    
    var descriptionPlural: String {
        switch self {
        case .ace:
            return "Aces"
        case .two:
            return "Twos"
        case .three:
            return "Threes"
        case .four:
            return "Fours"
        case .five:
            return "Fives"
        case .six:
            return "Sixes"
        case .seven:
            return "Sevens"
        case .eight:
            return "Eights"
        case .nine:
            return "Nines"
        case .ten:
            return "Tens"
        case .jack:
            return "Jacks"
        case .queen:
            return "Queens"
        case .king:
            return "Kings"
        }
    }
    
    var allSuits: [Card] {
        return [Card(rank: self, suit: .club), Card(rank: self, suit: .diamond), Card(rank: self, suit: .heart), Card(rank: self, suit: .spade)]
    }
}

enum Hand: Int, CaseIterable {
    case royal_flush = 9
    case straight_flush = 8
    case four_of_a_kind = 7
    case full_house = 6
    case flush = 5
    case straight = 4
    case three_of_a_kind = 3
    case two_pair = 2
    case one_pair = 1
    case high_card = 0
    
    var name: String {
        switch self {
        case .royal_flush:
            return "Royal Flush"
        case .straight_flush:
            return "Straight Flush"
        case .four_of_a_kind:
            return "Four Of A Kind"
        case .full_house:
            return "Full House"
        case .flush:
            return "Flush"
        case .straight:
            return "Straight"
        case .three_of_a_kind:
            return "Three Of A Kind"
        case .two_pair:
            return "2 Pair"
        case .one_pair:
            return "1 Pair"
        case .high_card:
            return "High Card"
        }
    }
    
    var description: String {
        switch self {
        case .royal_flush:
            return "The 10, Jack, Queen, King, and Ace of the same suit"
        case .straight_flush:
            return "Five cards of the same suit in sequence"
        case .four_of_a_kind:
            return "Four cards of the same rank"
        case .full_house:
            return "Three matching cards of one rank, with two matching cards of another"
        case .flush:
            return "Five cards of the same suit, but not in sequence"
        case .straight:
            return "Five cards of different suits in sequence"
        case .three_of_a_kind:
            return "Three cards of the same rank"
        case .two_pair:
            return "Two cards of the same rank, and two cards of another rank"
        case .one_pair:
            return "Two cards of the same rank"
        case .high_card:
            return "The card with the highest rank in your hand"
        }
    }
    
    var exampleHand: [Card] {
        switch self {
        case .royal_flush:
            return [Card(rank: .ace, suit: .heart), Card(rank: .king, suit: .heart), Card(rank: .queen, suit: .heart), Card(rank: .jack, suit: .heart), Card(rank: .ten, suit: .heart)]
        case .straight_flush:
            return [Card(rank: .nine, suit: .spade), Card(rank: .eight, suit: .spade), Card(rank: .seven, suit: .spade), Card(rank: .six, suit: .spade), Card(rank: .five, suit: .spade)]
        case .four_of_a_kind:
            return [Card(rank: .two, suit: .heart, side: .face_down), Card(rank: .seven, suit: .diamond), Card(rank: .seven, suit: .club), Card(rank: .seven, suit: .heart), Card(rank: .seven, suit: .spade)]
        case .full_house:
            return [Card(rank: .queen, suit: .heart), Card(rank: .queen, suit: .spade), Card(rank: .queen, suit: .diamond), Card(rank: .ace, suit: .club), Card(rank: .ace, suit: .heart)]
        case .flush:
            return [Card(rank: .king, suit: .club), Card(rank: .seven, suit: .club), Card(rank: .five, suit: .club), Card(rank: .three, suit: .club), Card(rank: .two, suit: .club)]
        case .straight:
            return [Card(rank: .jack, suit: .club), Card(rank: .ten, suit: .diamond), Card(rank: .nine, suit: .spade), Card(rank: .eight, suit: .heart), Card(rank: .seven, suit: .club)]
        case .three_of_a_kind:
            return [Card(rank: .nine, suit: .spade, side: .face_down), Card(rank: .two, suit: .heart, side: .face_down), Card(rank: .seven, suit: .diamond), Card(rank: .seven, suit: .club), Card(rank: .seven, suit: .heart)]
        case .two_pair:
            return [Card(rank: .three, suit: .heart, side: .face_down), Card(rank: .ten, suit: .diamond), Card(rank: .ten, suit: .club), Card(rank: .five, suit: .heart), Card(rank: .five, suit: .spade)]
        case .one_pair:
            return [Card(rank: .six, suit: .heart, side: .face_down), Card(rank: .five, suit: .spade, side: .face_down), Card(rank: .nine, suit: .heart, side: .face_down), Card(rank: .two, suit: .diamond), Card(rank: .two, suit: .club)]
        case .high_card:
            return [Card(rank: .six, suit: .club, side: .face_down), Card(rank: .two, suit: .heart, side: .face_down), Card(rank: .eight, suit: .spade, side: .face_down), Card(rank: .five, suit: .heart, side: .face_down), Card(rank: .ace, suit: .diamond)]
        }
    }
}

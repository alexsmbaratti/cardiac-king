//
//  Game.swift
//  Poker Face
//
//  Created by Alex Baratti on 12/14/22.
//

import Foundation

struct Game: Identifiable, Hashable, Codable {
    var id: Int = 0
    var name: String
    var steps: [Instruction] = []
    var wildRanks: [Rank] = []
    var wildCards: [Card] = []
    var wildCustoms: [String] = []
    var winningHands: [CardBunch] = []
    var rankValues: [CardBunch]?
    // TODO: Add special card values and behaviors
    var variants: [Variant] = []
    var format: GameFormat?
    var deferToFormat: Bool?
    
    func hasWilds() -> Bool {
        return !wildCards.isEmpty || !wildRanks.isEmpty || !wildCustoms.isEmpty
    }
    
    func hasWinningHands() -> Bool {
        return !winningHands.isEmpty
    }
    
    func hasVariants() -> Bool {
        return !variants.isEmpty
    }
    
    func hasRankValues() -> Bool {
        return rankValues != nil && !rankValues!.isEmpty
    }
    
    func getAllWildCards() -> [CardBunch] {
        let rankBunches: [CardBunch] = wildRanks.map({ CardBunch(description: $0.descriptionPlural, cards: $0.allSuits) })
        let cardBunches: [CardBunch] = wildCards.map({ CardBunch(description: $0.description, cards: [$0]) })
        let customBunches: [CardBunch] = wildCustoms.map({ CardBunch(description: $0, cards: []) })
        return rankBunches + cardBunches + customBunches
    }
}

struct Instruction: Hashable, Codable {
    var description: String
    var subtext: String?
}

enum InstructionType: Int, Codable {
    case generic
    case ante_pay
}

struct Variant: Hashable, Codable {
    var name: String
    var description: String
}

enum GameFormat: String, Codable {
    /**
     Deal five cards face down, discard unwanted cards, and exchange for new cards
     */
    case five_card_draw = "five_card_draw"
    /**
     Two cards down, four up, one down
     */
    case seven_card_stud = "seven_card_stud"
    /**
     Three cards down, flip one card up, build your own hand
     */
    case roll_your_own = "roll_your_own"
    
    var name: String {
        switch self {
        case .five_card_draw:
            return "Five-Card Draw"
        case .roll_your_own:
            return "Roll Your Own"
        case .seven_card_stud:
            return "Seven-Card Stud"
        }
    }
}

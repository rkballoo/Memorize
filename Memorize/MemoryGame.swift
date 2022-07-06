//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rajiv Balloo on 2022-04-22.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score: Int
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue)} }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    cards[potentialMatchIndex].addTimeFaceUp()
                    score += Int(max(cards[chosenIndex].timeRemaining() , 1)) +
                                 Int(max( cards[potentialMatchIndex].timeRemaining() , 1))
                } else {
                    if(cards[chosenIndex].wasPreviouslySeen) {
                        score -= Int(cards[chosenIndex].timeElapsed())
                    }
                    if(cards[potentialMatchIndex].wasPreviouslySeen) {
                        score -= Int(cards[potentialMatchIndex].timeElapsed())
                    }
                }
            } else {
                for index in cards.indices {
                    cards[index].addTimeFaceUp()
                    cards[index].isFaceUp = false
                }
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(content: [CardContent], numberOfPairsOfCards: Int) {
        cards = []
        score = 0
        
        let shuffledSetContent = content.shuffled()
        // add numberOfPairOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = shuffledSetContent[pairIndex]
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    timeSinceFaceUp = Date()
                    if !wasPreviouslySeen { wasPreviouslySeen = true }
                } else {
                    timeSinceFaceUp = nil
                }
            }
        }
        var timeSinceFaceUp: Date?
        var totalTimeFaceUp: TimeInterval = 0
        var isMatched = false
        var wasPreviouslySeen = false
        let content: CardContent
        let id: Int
        
        func timeRemaining() -> TimeInterval {
            max((10 - totalTimeFaceUp), 0)
        }
        
        func timeElapsed() -> TimeInterval {
            min(totalTimeFaceUp, 10)
        }
        
        mutating func addTimeFaceUp() {
            if let time = timeSinceFaceUp {
                totalTimeFaceUp += Date().timeIntervalSince(time)
            }
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


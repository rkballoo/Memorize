//
//  Theme.swift
//  Memorize
//
//  Created by Rajiv Balloo on 2022-05-12.
//

import Foundation

struct Theme<CardContent> {
    var name: String
    var setContent: [CardContent]
    private var numberOfPairsOfCards: Int
    var randomNumberOfCards = false
    var color: String
    
    init(_ name: String, using: [CardContent], numberOfPairsOfCards: Int, color: String) {
        self.name = name
        setContent = using
        self.color = color
        if(numberOfPairsOfCards > using.count) {
            self.numberOfPairsOfCards = using.count
        } else {
            self.numberOfPairsOfCards = numberOfPairsOfCards
        }
    }
    
    init(_ name: String, using: [CardContent], color: String) {
        self.name = name
        setContent = using
        self.color = color
        self.numberOfPairsOfCards = using.count
    }
    
    init(_ name: String, using: [CardContent], randomNumberOfCards: Bool, color: String) {
        self.name = name
        setContent = using
        self.color = color
        self.randomNumberOfCards = randomNumberOfCards
        self.numberOfPairsOfCards = using.count

    }
    
    func getNumberOfPairsOfCards() -> Int {
        if(randomNumberOfCards) {
            return Int.random(in: 4...setContent.count)
        } else {
            return numberOfPairsOfCards
        }
    }
}

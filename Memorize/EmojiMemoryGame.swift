//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rajiv Balloo on 2022-04-22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private(set) static var themes =
    [
        Theme<String>(
            "Vehicles",
            using: ["🚑", "🏎", "🚓", "🚎", "🚕", "🛻", "🛴", "🛵", "🛺", "🚲",
                         "🦼", "🚚", "🚛", "✈️"],
            numberOfPairsOfCards: 10,
            color: "blue"),
        Theme<String>(
            "Faces",
            using: ["😀", "😂", "🤪", "😍", "😢", "😡", "😎", "😇", "🥶", "😈",
                         "🤑", "🤢", "🫥", "😐", "😵‍💫", "🥴", "😪"],
            randomNumberOfCards: true,
            color: "instaGradient"),
        Theme<String>(
            "Halloween",
            using: ["🎃", "👻", "💀", "🤡", "👹", "👽", "🤖"],
            numberOfPairsOfCards: 8,
            color: "orange"),
        Theme<String>(
            "Tech",
            using: ["📱", "💻", "⌚️", "🖥", "📷", "🖨"],
            color: "purple"),
        Theme<String>(
            "Animals",
            using: ["🐶", "🐱", "🐭", "🦊", "🐻", "🐼", "🐻‍❄️", "🐮"],
            randomNumberOfCards: true,
            color: "red"),
        Theme<String>(
            "Fruits",
            using: ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇"],
            numberOfPairsOfCards: 7,
            color: "green"),
    ]
    
    
    private static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        return MemoryGame<String>(
            content: theme.setContent,
            numberOfPairsOfCards: theme.getNumberOfPairsOfCards())
    }
    
    static func assignRandomTheme() -> Theme<String> {
        if let randomTheme = themes.randomElement() {
            return randomTheme
        } else {
            return themes[0]
        }
    }
    
    @Published private var currentTheme: Theme<String>
    @Published private var model: MemoryGame<String>
    
    init() {
        let theme = EmojiMemoryGame.assignRandomTheme()
        currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var currentThemeColor: LinearGradient {
        var color: LinearGradient
        switch currentTheme.color {
            case "red":
                color = LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom)
            case "blue":
                color = LinearGradient(colors: [.blue], startPoint: .top, endPoint: .bottom)
            case "green":
                color = LinearGradient(colors: [.green], startPoint: .top, endPoint: .bottom)
            case "purple":
                color = LinearGradient(colors: [.purple], startPoint: .top, endPoint: .bottom)
            case "orange":
                color = LinearGradient(colors: [.orange], startPoint: .top, endPoint: .bottom)
            case "yellow":
                color = LinearGradient(colors: [.yellow], startPoint: .top, endPoint: .bottom)
            case "indigo":
                color = LinearGradient(colors: [.indigo], startPoint: .top, endPoint: .bottom)
            case "instaGradient":
                color = LinearGradient(colors: [.red, .orange, .yellow], startPoint: .topTrailing, endPoint: .bottomLeading)
            default:
                color = LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom)
        }
        return color
    }
    
    var currentThemeName: String {
        return currentTheme.name
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        currentTheme = EmojiMemoryGame.assignRandomTheme()
        model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
    }
    
    func shuffle() {
        model.shuffle()
    }
}

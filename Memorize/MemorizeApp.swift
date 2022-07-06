//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rajiv Balloo on 2022-04-17.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}

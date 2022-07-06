//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Rajiv Balloo on 2022-04-17.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text(game.currentThemeName)
                    .font(.largeTitle)
                Text("Score: \(game.score)")
                gameBody
                LazyVGrid(columns: [GridItem(.flexible(minimum: 70)), GridItem(.flexible(minimum: 70)), GridItem(.flexible(minimum: 70))]) {
                    newGame
                    restart
                    shuffle
                }
            }
            deckBody
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id } ) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card, color: game.currentThemeColor)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(CardConstants.cardPadding)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, color: game.currentThemeColor)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealthWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation() {
                dealt = []
                game.newGame()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation() {
                dealt = []
                game.restart()
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cardPadding: CGFloat = 4
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double =  2
        static let undealtHeight: CGFloat = 90
        static let undealthWidth = undealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return Group {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
                .previewInterfaceOrientation(.portrait)
        }
    }
}

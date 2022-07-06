//
//  CardView.swift
//  Memorize
//
//  Created by Rajiv Keshav Balloo on 2022-05-31.
//

import SwiftUI

struct CardView: View {
    let card: EmojiMemoryGame.Card
    let color: LinearGradient
    
    @State private var animatedTimeRemaining: Double = 10
    
    var body: some View{
        GeometryReader { geometry in
            ZStack {
                color.mask(
                    Group {
                        if card.isFaceUp && card.timeRemaining() != 0 {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedTimeRemaining/10)*360-90))
                                .onAppear {
                                    animatedTimeRemaining = card.timeRemaining()
                                    withAnimation(.linear(duration: card.timeRemaining())) {
                                        animatedTimeRemaining = 0
                                    }
                                }
                        } else {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (card.timeRemaining()/10)*360-90))
                        }
                    }
                    .padding(DrawingConstants.timerPadding)
                    .opacity(DrawingConstants.timerOpacity)
                    )
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, color: color)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontScale / DrawingConstants.fontSize
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.65
        static let fontSize: CGFloat = 32
        
        static let timerPadding: CGFloat = 5
        static let timerOpacity: Double = 0.5
    }
}

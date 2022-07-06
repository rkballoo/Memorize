//
//  Cardify.swift
//  Memorize
//
//  Created by Rajiv Keshav Balloo on 2022-05-31.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool, color: LinearGradient) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    
    let color: LinearGradient
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                color.mask(shape.strokeBorder(lineWidth: DrawingConstants.lineWidth))
            } else {
                shape.fill(color)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: LinearGradient) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}

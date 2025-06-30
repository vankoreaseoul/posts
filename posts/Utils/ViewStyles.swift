//
//  ViewStyles.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    
    @Environment(\.refresh) private var refresh
    
    let title: String
    var fontSize: CGFloat = TEXT_FONT_SIZE
    var verticalPadding: CGFloat = 8
    var horizontalPadding: CGFloat = 0
    var bgColor: Color = .blue
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button {
            action()
            
            Task { await refresh?() }
            
        } label: {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(disabled)
    }
}

struct CustomTextView: View {
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(title):")
                .bold()
            
            Text(text)
                .multilineTextAlignment(.leading)
        }
        .font(.system(size: TEXT_FONT_SIZE))
    }
}

struct ShimmerViewModifier: ViewModifier {
    
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width, height: geo.size.height)
                    .rotationEffect(.degrees(30))
                    .offset(x: phase * geo.size.width)
                    .blendMode(.overlay)
                }
            }
            .mask(alignment: .center) {
                content
            }
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
        
    }
}

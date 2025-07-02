//
//  ViewStyles.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    
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
    private let title: String
    private let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
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

struct CustomSectionView<Content: View>: View {
    private let header: String
    private let isBtnHidden: Bool
    private let isBtnDefault: Bool
    private let action: (() -> Void)?
    private let content: Content
    
    init(header: String, isBtnHidden: Bool = true, isBtnDefault: Bool = true, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.header = header
        self.isBtnHidden = isBtnHidden
        self.isBtnDefault = isBtnDefault
        self.action = action
        self.content = content()
    }

    var body: some View {
        Section(header:
                    HStack(spacing: 0) {
            Text(header)
                .font(.headline)
            
            Spacer(minLength: 4)
            
            if !isBtnHidden {
                Button {
                    action?()
                } label: {
                    Image(systemName: "chevron.\(isBtnDefault ? "down" : "up")")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.bottom, 4)
        ) { content }
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

//
//  ViewStyles.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import SwiftUI

struct PaddingModifier: ViewModifier {
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content.padding(padding)
    }
}

struct CustomButton: View {
    let title: String
    var fontSize: CGFloat = TEXT_FONT_SIZE
    var verticalPadding: CGFloat = 8
    var horizontalPadding: CGFloat = 0
    var bgColor: Color = .blue
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
        }
        .font(.system(size: TEXT_FONT_SIZE))
    }
}

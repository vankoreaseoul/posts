//
//  NoticeView.swift
//  posts
//
//  Created by Heawon Seo on 7/2/25.
//

import SwiftUI

struct NoticeView: View {
    
    private let text: String
    private let btnTitle: String
    private let isBtnHidden: Bool
    
    @Binding private var isBtnTapped: Bool
    
    init(text: String, btnTitle: String = "", isBtnHidden: Bool = false, isBtnTapped: Binding<Bool> = .constant(false)) {
        self.text = text
        self.btnTitle = btnTitle
        self.isBtnHidden = isBtnHidden
        _isBtnTapped = isBtnTapped
    }
    
    var body: some View {
        
        VStack(spacing: 32) {
            Text(text)
                .font(.system(size: TITLE_FONT_SIZE))
                .multilineTextAlignment(.center)
            
            if !isBtnHidden {
                CustomButton(title: btnTitle, verticalPadding: 12) { isBtnTapped.toggle() }.padding(.horizontal, 32)
            }
        }
        .padding(.horizontal, 16)
        
    }
}

#Preview {
    NoticeView(text: "test", btnTitle: "button")
}

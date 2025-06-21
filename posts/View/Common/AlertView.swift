//
//  AlertView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct AlertView: View {
    
    @Binding private var msg: String?
    @State private var errorMsg: String
    
    init(msg: Binding<String?>) {
        _msg = msg
        errorMsg = msg.wrappedValue ?? ""
    }
    
//    init(msg: String?) {
//        _msg = msg
//        errorMsg = msg.wrappedValue ?? ""
//    }
    
    private func didTapOkBtn() { msg = nil }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Notice")
                    .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(.blue.opacity(0.5))
                
                Text(errorMsg)
                    .font(.system(size: TEXT_FONT_SIZE))
                    .multilineTextAlignment(.center)
                    .padding([.horizontal, .top], 16)
                    .padding(.bottom, 28)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                CustomButton(title: "OK") {
                    didTapOkBtn()
                }
                .padding([.bottom, .horizontal], 16)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
        }
        
        
    }
}

#Preview {
    AlertView(msg: .constant("test"))
}

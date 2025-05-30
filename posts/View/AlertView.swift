//
//  AlertView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var msg: String?
    @State private var errorMsg: String = ""
    
    init(msg: Binding<String?>) {
        self._msg = msg
        _errorMsg = State(initialValue: msg.wrappedValue ?? "")
    }
    
    private func didTapOkBtn() { msg = nil }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Notice")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(.blue.opacity(0.5))
                
                Text(errorMsg)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding([.horizontal, .top], 16)
                    .padding(.bottom, 28)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button {
                    didTapOkBtn()
                } label: {
                    Text("Ok")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.blue.opacity(0.5))
                        }
                }
                .padding(.bottom, 16)
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

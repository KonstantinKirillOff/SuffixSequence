//
//  SearchField.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 30.07.2024.
//

import SwiftUI

struct CustomTextFieldView: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Enter your text...", text: $text)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 25))
            .frame(height: 30)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            }
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 5)
                        }
                    }
                }
            )
    } 
}

#Preview {
    CustomTextFieldView(text: .constant("text"))
}
